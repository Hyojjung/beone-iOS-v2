
import UIKit

protocol TimeSelectViewDelegate: NSObjectProtocol {
  func selectTimeRangeButtonTapped(index: Int)
}

class TimeSelectView: UIView {
  
  var hourLines = [UIView]()
  weak var delegate: TimeSelectViewDelegate?
  
  func layoutView(timeRanges: [AvailableTimeRange], selectedTimeRange: AvailableTimeRange?) {
    backgroundColor = gold
    if let startDateTime = timeRanges.first?.startDateTime, endDateTime = timeRanges.last?.endDateTime {
      addHourViews(startDateTime, endDateTime: endDateTime)
      addHourSelectViews(timeRanges, selectedTimeRange: selectedTimeRange, startDateTime: startDateTime)
    }
  }
  
  private func addHourViews(startDateTime: NSDate, endDateTime: NSDate) {
    hourLines.removeAll()
    let hourLineCount = endDateTime.hourIntervalFromDate(startDateTime) + 1
    for index in 0..<hourLineCount {
      addHourView(startDateTime.hour() + index)
    }
    addBottomLayout(hourLines.last!, constant: 8)
  }
  
  private func addHourSelectViews(timeRanges: [AvailableTimeRange], selectedTimeRange: AvailableTimeRange?, startDateTime: NSDate) {
    for (index, timeRange) in timeRanges.enumerate() {
      let startLineIndex = timeRange.startDateTime!.hour() - startDateTime.hour()
      let endLineIndex = timeRange.endDateTime!.hour() - startDateTime.hour()
      
      let startHourLine = hourLines[startLineIndex]
      let endHourLine = hourLines[endLineIndex]
      
      addHourSelectView(timeRange, selectedTimeRange: selectedTimeRange, index: index,
        startHourLine: startHourLine, endHourLine: endHourLine)
    }
  }
  
  private func addHourSelectView(timeRange: AvailableTimeRange, selectedTimeRange: AvailableTimeRange?, index: Int,
    startHourLine: UIView, endHourLine: UIView) {
      let selectView = self.selectView(timeRange, index: index, isSelected: timeRange == selectedTimeRange)
      
      addVerticalLayout(startHourLine, bottomView: selectView, contsant: 6)
      addVerticalLayout(selectView, bottomView: endHourLine, contsant: 6)
      addLeftLayout(startHourLine, rightView: selectView, contsant: 34)
      addRightLayout(selectView, rightView: startHourLine, contsant: 34)
  }
  
  private func addHourView(hour: Int) {
    let hourLabel = self.hourLabel(hour)
    addSubViewAndEnableAutoLayout(hourLabel)
    addLeadingLayout(hourLabel)
    if let lastHourLine = hourLines.last {
      addVerticalLayout(lastHourLine, bottomView: hourLabel, contsant: 41)
    } else {
      addTopLayout(hourLabel)
    }
    
    let lineView = self.lineView()
    addSubViewAndEnableAutoLayout(lineView)
    addTrailingLayout(lineView)
    addHorizontalLayout(hourLabel, rightView: lineView, contsant: 3.4)
    addConstraint(NSLayoutConstraint(item: hourLabel,
      attribute: .CenterY,
      relatedBy: .Equal,
      toItem: lineView,
      attribute: .CenterY,
      multiplier: 1,
      constant: 0))
  }
}

// MARK: - Action

extension TimeSelectView {
  func timeSelectButtonTapped(sender: UIButton) {
    let index = sender.tag
    delegate?.selectTimeRangeButtonTapped(index)
  }
}

extension TimeSelectView {
  
  private func timeSelectViewLabel() -> UILabel {
    let timeSelectViewLabel = UILabel()
    timeSelectViewLabel.font = UIFont.systemFontOfSize(15)
    timeSelectViewLabel.textColor = UIColor.whiteColor()
    return timeSelectViewLabel
  }
  
  private func lineView() -> UIView {
    let lineView = UIView()
    lineView.backgroundColor = UIColor.whiteColor()
    lineView.addHeightLayout(1)
    hourLines.append(lineView)
    return lineView
  }
  
  private func hourLabel(hour: Int) -> UILabel {
    let hourLabel = timeSelectViewLabel()
    hourLabel.addWidthLayout(66)
    
    if hour < kNoonTime {
      hourLabel.text = "AM \(hour):00"
    } else if hour == kNoonTime {
      hourLabel.text = "PM \(hour):00"
    } else {
      hourLabel.text = "PM \(hour - kNoonTime):00"
    }
    return hourLabel
  }
  
  private func timeRangeLabel(timeRange: AvailableTimeRange) -> UILabel {
    let timeRangeLabel = timeSelectViewLabel()
    timeRangeLabel.text = timeRange.timeRangeNotation()
    return timeRangeLabel
  }
  
  private func selectView(timeRange: AvailableTimeRange, index: Int, isSelected: Bool) -> UIView {
    let selectView = UIView()
    addSubViewAndEnableAutoLayout(selectView)
    
    let selectButton = UIButton()
    selectButton.tag = index
    selectView.addSubViewAndEdgeLayout(selectButton)
    selectButton.addTarget(self, action: "timeSelectButtonTapped:", forControlEvents: .TouchUpInside)
    selectButton.setBackgroundImage(UIImage(named: "btnTimeSelectAreaActive"), forState: .Normal)
    selectButton.setBackgroundImage(UIImage(named: "btnTimeSelectArea"), forState: .Selected)
    selectButton.selected = isSelected
    
    let hourLabel = self.timeRangeLabel(timeRange)
    selectView.addSubViewAndCenterLayout(hourLabel)
    
    return selectView
  }
}
