require_relative "../config/environment.rb"

class Student
 attr_accessor :name,:grade 
 attr_reader :id
 
 def initialize(id = nil, name,grade)
   @name = name 
   @grade = grade
 end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table 
    DB[:conn].execute("DROP TABLE students")
  end 
  
  def save
    if @id == nil
      sql = <<-SQL 
        INSERT INTO students(name,grade) 
        VALUES (?,?)
      SQL
      
      DB[:conn].execute(sql,self.name, self.grade)  
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      self
    else 
      DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?",self.name,self.grade, self.id)  
      self
      
    end
    
  end
  
  def self.create(name, grade) 
    new_stud = self.new(name,grade) 
    new_stud.save 
    new_stud
  end
  
  def self.new_from_db(row) 
    new_stud = Student.new 
    new_stud
  end
end
