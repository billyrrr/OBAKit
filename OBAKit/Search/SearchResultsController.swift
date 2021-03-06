//
//  SearchResultsController.swift
//  OBANext
//
//  Copyright © Open Transit Software Foundation
//  This source code is licensed under the Apache 2.0 license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit
import IGListKit
import OBAKitCore
import MapKit

// swiftlint:disable cyclomatic_complexity

public class SearchResultsController: UIViewController, AppContext, ListAdapterDataSource {
    public lazy var collectionController = CollectionController(application: application, dataSource: self)
    var scrollView: UIScrollView { collectionController.collectionView }

    private weak var delegate: ModalDelegate?

    let application: Application

    private let searchResponse: SearchResponse

    private let titleView = StackedTitleView.autolayoutNew()

    public init(searchResponse: SearchResponse, application: Application, delegate: ModalDelegate?) {
        self.searchResponse = searchResponse
        self.application = application
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        title = OBALoc("search_results_controller.title", value: "Search Results", comment: "The title of the Search Results controller.")
        titleView.titleLabel.text = title
        titleView.subtitleLabel.text = subtitleText(from: searchResponse)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UIViewController Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleView

        view.backgroundColor = ThemeColors.shared.systemBackground
        addChildController(collectionController)
        collectionController.view.pinToSuperview(.edges)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.close, style: .plain, target: self, action: #selector(close))
    }

    // MARK: - Actions

    @objc private func close() {
        delegate?.dismissModalController(self)
    }

    // MARK: - Private

    private func subtitleText(from response: SearchResponse) -> String {
        let subtitleFormat: String
        switch searchResponse.request.searchType {
        case .address:
            subtitleFormat = OBALoc("search_results_controller.subtitle.address_fmt", value: "%@", comment: "A format string for address searches. In English, this is just the address itself without any adornment.")
        case .route:
            subtitleFormat = OBALoc("search_results_controller.subtitle.route_fmt", value: "Route %@", comment: "A format string for route searches. e.g. in english: Route \"{SEARCH TEXT}\"")
        case .stopNumber:
            subtitleFormat = OBALoc("search_results_controller.subtitle.stop_number_fmt", value: "Stop number %@", comment: "A format string for stop number searches. e.g. in english: Stop number \"{SEARCH TEXT}\"")
        case .vehicleID:
            subtitleFormat = OBALoc("search_results_controller.subtitle.vehicle_id_fmt", value: "Vehicle ID %@", comment: "A format string for vehicle ID searches. e.g. in english: Vehicle ID \"{SEARCH TEXT}\"")
        }
        return String(format: subtitleFormat, searchResponse.request.query)
    }

    // MARK: - ListAdapterDataSource

    private func tableRowData(from item: Any) -> TableRowData? {
        let row: TableRowData

        let tapHandler: ListRowActionHandler = { [weak self] _ in
            guard let self = self else { return }
            let mgr = self.application.mapRegionManager
            mgr.searchResponse = SearchResponse(response: self.searchResponse, substituteResult: item)
            self.delegate?.dismissModalController(self)
        }

        switch item {
        case let item as MKMapItem:
            if let name = item.name {
                row = TableRowData(title: name, accessoryType: .none, tapped: tapHandler)
            }
            else {
                return nil
            }
        case let item as Route:
            row = TableRowData(title: item.shortName, subtitle: item.agency.name, accessoryType: .none, tapped: tapHandler)
        case let item as Stop:
            row = TableRowData(title: item.name, accessoryType: .none, tapped: tapHandler)
        case let item as AgencyVehicle:
            guard
                let vehicleID = item.vehicleID,
                let apiService = application.restAPIService
            else {
                return nil
            }
            row = TableRowData(title: vehicleID, subtitle: item.agencyName, accessoryType: .none) { [weak self] _ in
                let op = apiService.getVehicle(vehicleID)
                op.complete { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .failure(let error):
                        self.application.displayError(error)
                    case .success(let response):
                        let response = SearchResponse(response: self.searchResponse, substituteResult: response.entry)
                        self.application.mapRegionManager.searchResponse = response
                        self.delegate?.dismissModalController(self)
                    }
                }
            }

        default:
            return nil
        }

        return row
    }

    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let rows = searchResponse.results.compactMap { tableRowData(from: $0) }
        let tableSection = TableSectionData(rows: rows)
        return [tableSection]
    }

    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return defaultSectionController(for: object)
    }

    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
