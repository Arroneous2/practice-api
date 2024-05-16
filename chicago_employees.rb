require "http"

chicago_employees = HTTP.get("https://data.cityofchicago.org/resource/xzkq-xp2w.json").parse

chicago_departments = []
# print the first of each department
chicago_employees.each {|chicago_employee|
  #first can you print by department
  if chicago_employee["department"] == "CHICAGO PUBLIC LIBRARY"
    p chicago_employee["department"]
  end

  chicago_departments.push(chicago_employee["department"])
}

chicago_employees.each {|chicago_employee|
  #first can you print by department
  if chicago_employee["department"] == "CHICAGO PUBLIC LIBRARY"
    p chicago_employee["department"]
  end

  chicago_departments.push(chicago_employee["department"])
}

p chicago_departments.uniq