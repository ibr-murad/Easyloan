//
//  StatisticsViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: BaseViewController {
    
    // MARK: - Private Variables
    
    private var dateFrom: String {
        var dateComponent = DateComponents()
        dateComponent.month = -3
        guard let date = Calendar.current.date(byAdding: dateComponent, to: Date()) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private var dateTo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    
    // MARK: - Instantiate
    
    static func instantiate() -> StatisticsViewController {
        let storyboard = UIStoryboard(name: "Statistics", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? StatisticsViewController
            else { return StatisticsViewController() }
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingAlert()
        self.setNavigationBar()
        self.setStatisticVisible(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchStaistic(from: self.dateFrom, to: self.dateTo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        self.presentPopoverViewController(controller: FilterPopoverViewController.instantiate(),
                                          sourceView: sender.plainView,
                                          size: CGSize(width: UIScreen.main.bounds.width, height: 350),
                                          minusY: -12, arrowDirection: .up)
    }
    
    // MARK: - Setters
    
    private func setNavigationBar() {
        guard let color = UIColor(named: "appColor") else { return }
        self.setupNavBar(style: .black, backgroungColor: color, tintColor: .white)
    }
    
    // MARK: - Networking
    
    private func fetchStaistic(from: String, to: String) {
        
        /*Network.shared.request(
            url: URLPath.dashboard, method: .get,
            /*parameters: ["to": to,
                         "from": from],*/
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { (data: DashboardModel) in
                self.dismiss(animated: true, completion: nil)
        }) { (error, code) in
            self.dismiss(animated: true, completion: {
                self.alertError(message: error.msg)
            })
        }*/
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.barChartUpdate()
            self.setStatisticVisible(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func setStatisticVisible(_ value: Bool) {
        if value {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0
                self.barChartView.alpha = 1
                self.barChartView.animate(xAxisDuration: 1)
                self.barChartView.animate(yAxisDuration: 3)
                self.view.setNeedsLayout()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 1
                self.barChartView.alpha = 0
                self.view.setNeedsLayout()
            }
        }
    }
    
    private func barChartUpdate () {
        let entry1 = BarChartDataEntry(x: 1.0, y: 516.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 624.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 94.0)
        let entry4 = BarChartDataEntry(x: 4.0, y: 333.0)
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4], label: nil)
        dataSet.colors = [
            NSUIColor(named: "appColor")!,
            NSUIColor(named: "lineColor")!,
            NSUIColor(named: "authSmsColor")!,
            NSUIColor(named: "greenTextColor")!]
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [dataSet])
        data.barWidth = 0.6
        
        self.barChartView.xAxis.enabled = false
        self.barChartView.leftAxis.enabled = false
        self.barChartView.rightAxis.enabled = false
        self.barChartView.drawBordersEnabled = false
        self.barChartView.legend.enabled = false
        self.barChartView.isUserInteractionEnabled = false
        self.barChartView.data = data
        
        self.barChartView.notifyDataSetChanged()
    }
    
}
