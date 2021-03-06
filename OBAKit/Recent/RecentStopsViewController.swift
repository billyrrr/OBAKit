//
//  RecentStopsViewController.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 5/20/19.
//

import UIKit
import IGListKit
import OBAKitCore

/// Provides an interface to browse recently-viewed information, mostly `Stop`s.
public class RecentStopsViewController: UIViewController,
    AppContext,
    ListAdapterDataSource,
    SectionDataBuilders {

    let application: Application

    // MARK: - Init

    public init(application: Application) {
        self.application = application

        super.init(nibName: nil, bundle: nil)

        title = OBALoc("recent_stops_controller.title", value: "Recent", comment: "The title of the Recent Stops controller.")
        tabBarItem.image = Icons.recentTabIcon
        tabBarItem.selectedImage = Icons.recentSelectedTabIcon
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: OBALoc("recent_stops.delete_all", value: "Delete All", comment: "A button that deletes all of the recent stops in the app."), style: .plain, target: self, action: #selector(deleteAll))

        view.backgroundColor = ThemeColors.shared.systemBackground
        addChildController(collectionController)
        collectionController.view.pinToSuperview(.edges)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        application.userDataStore.deleteExpiredAlarms()

        collectionController.reload(animated: false)
    }

    // MARK: - Data and Collection Controller

    private lazy var collectionController = CollectionController(application: application, dataSource: self)

    // MARK: - Actions

    @objc func deleteAll() {
        let title = OBALoc("recent_stops.confirmation_alert.title", value: "Are you sure you want to delete all of your recent stops?", comment: "Title for a confirmation alert displayed before the user deletes all of their recent stops.")

        let alertController = UIAlertController.deletionAlert(title: title) { [weak self] _ in
            guard let self = self else { return }
            self.application.userDataStore.deleteAllRecentStops()
            self.collectionController.reload(animated: false)
        }

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - ListAdapterDataSource

    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var sections: [ListDiffable] = []
        sections.append(contentsOf: alarmsSection)
        sections.append(contentsOf: stopsSection)
        return sections
    }

    private var alarmsSection: [ListDiffable] {
        let alarms = application.userDataStore.alarms
        guard alarms.count > 0 else {
            return []
        }

        let rows = alarms.compactMap { [weak self] a -> TableRowData? in
            guard let deepLink = a.deepLink else { return nil }
            let rowData = TableRowData(title: deepLink.title, accessoryType: .disclosureIndicator) { _ in
                guard
                    let self = self,
                    let apiService = self.application.restAPIService
                else { return }

                SVProgressHUD.show()

                let op = apiService.getTripArrivalDepartureAtStop(stopID: deepLink.stopID, tripID: deepLink.tripID, serviceDate: deepLink.serviceDate, vehicleID: deepLink.vehicleID, stopSequence: deepLink.stopSequence)
                op.complete { [weak self] result in
                    SVProgressHUD.dismiss()

                    guard let self = self else { return }

                    switch result {
                    case .failure(let error):
                        self.application.displayError(error)
                    case .success(let response):
                        self.application.viewRouter.navigateTo(arrivalDeparture: response.entry, from: self)
                    }
                }
            }

            rowData.deleted = { [weak self] _ in
                guard let self = self else { return }
                self.application.obacoService?.deleteAlarm(url: a.url)
                self.application.userDataStore.delete(alarm: a)
                self.collectionController.reload(animated: true)
            }

            return rowData
        }

        return [
            TableHeaderData(title: OBALoc("recent_stops_controller.alarms_section.title", value: "Alarms", comment: "Title of the Alarms section of the Recents controller")),
            TableSectionData(rows: rows)
        ]
    }

    private var stopsSection: [ListDiffable] {
        let stops = application.userDataStore.recentStops
        guard stops.count > 0 else {
            return []
        }

        let tapHandler = { (vm: ListViewModel) -> Void in
            guard let stop = vm.object as? Stop else { return }
            self.application.viewRouter.navigateTo(stop: stop, from: self)
        }

        let deleteHandler = { (vm: ListViewModel) -> Void in
            guard let stop = vm.object as? Stop else { return }
            self.application.userDataStore.delete(recentStop: stop)
            self.collectionController.reload(animated: true)
        }

        var sections = [ListDiffable]()

        if application.userDataStore.alarms.count > 0 {
            sections.append(TableHeaderData(title: Strings.recentStops))
        }

        let section = tableSection(stops: stops, tapped: tapHandler, deleted: deleteHandler)
        sections.append(section)

        return sections
    }

    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return defaultSectionController(for: object)
    }

    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let emptyView = EmptyDataSetView()
        emptyView.titleLabel.text = OBALoc("recent_stops.empty_set.title", value: "No Recent Stops", comment: "Title for the empty set indicator on the Recent Stops controller.")
        emptyView.bodyLabel.text = OBALoc("recent_stops.empty_set.body", value: "Transit stops that you view in the app will appear here.", comment: "Body for the empty set indicator on the Recent Stops controller.")

        return emptyView
    }
}
