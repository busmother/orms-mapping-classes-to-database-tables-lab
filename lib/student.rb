class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students(name, grade)
    VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    id = <<-SQL
    SELECT last_insert_rowid()
    SQL
    student_id = DB[:conn].execute(id)[0][0]
    @id = student_id
  end

  def self.create(hash)
    #extract name and grade from the hash
    #binding.pry
    name = hash[:name]
    grade = hash[:grade]
    student = Student.new(name, grade)
    student.save
    student
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end
