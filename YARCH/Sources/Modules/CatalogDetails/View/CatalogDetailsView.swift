// Главная вью модуля CatalogDetails

import UIKit

extension CatalogDetailsView {
    struct Appearance {
        let tableRowHeight: CGFloat = 60
        let tableHeaderViewHeight: CGFloat = 150
    }
}

class CatalogDetailsView: UIView {

    weak var refreshActionsDelegate: CatalogErrorViewDelegate?

    let appearance: Appearance

    var tableView: UITableView

    var tableHeaderView: CatalogDetailsHeaderView? {
        return tableView.tableHeaderView as? CatalogDetailsHeaderView
    }

    lazy var emptyView = CatalogEmptyView()

    lazy var errorView: CatalogErrorView = {
        let view = CatalogErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()

    init(frame: CGRect = CGRect.zero,
         loadingDataSource: UITableViewDataSource,
         loadingDelegate: UITableViewDelegate,
         refreshDelegate: CatalogErrorViewDelegate, appearance: Appearance = Appearance()) {

        tableView = UITableView(delegate: loadingDelegate, dataSource: loadingDataSource)
        self.appearance = appearance
        super.init(frame: frame)
        refreshActionsDelegate = refreshDelegate
        configureTableView()
        addSubviews()
        makeConstraints()

        emptyView.isHidden = true
        tableView.isHidden = true
        errorView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration

    func configureHeaderView(_ viewModel: CoinSnapshotFullViewModel) {
        if let image = viewModel.image {
            tableHeaderView?.imageView.image = image
        } else {
            tableHeaderView?.imageView.showPlaceholder()
        }
    }

    func configureTableView() {
        #if !(os(tvOS))
        tableView.separatorStyle = .none
        #endif
        tableView.rowHeight = appearance.tableRowHeight
        tableView.tableHeaderView = CatalogDetailsHeaderView()
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    func updateTableViewData(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        showTable()
        tableView.tableFooterView = nil
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.reloadData()
    }

    func addSubviews() {
        addSubview(tableView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    func showLoading() {
        show(view: tableView)
    }

    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }

    func showTable() {
        show(view: tableView)
    }

    func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }

    // MARK: Layout

	func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableHeaderView?.snp.makeConstraints { (make) in
            make.width.equalTo(tableView)
            make.height.equalTo(appearance.tableHeaderViewHeight)
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
	}
}

extension CatalogDetailsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
