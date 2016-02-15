class Employee

  attr_accessor :name, :boss, :salary

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end

end

class Manager < Employee

  attr_accessor  :employees
  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    salary = 0
    employees.each do |employee|
      salary += employee.salary
      salary += employee.bonus(1) if employee.is_a?(Manager)
    end
    salary * multiplier
  end
end


david = Employee.new("David", "TA", 10000, "Darren")
shawna = Employee.new("Shawna", "TA", 12000, "Darren")
darren = Manager.new("Darren", "TA Manager", 78000, "Ned", ["David", "Shawna"])
ned = Manager.new("Ned", "Founder", 1000000, nil, ["Darren"])

david.boss = darren
shawna.boss = darren
darren.boss = ned

darren.employees = [shawna, david]
ned.employees = [darren]

p ned.bonus(5) # => 500_000
#p darren.bonus(4) # => 88_000
#p david.bonus(3) # => 30_000
