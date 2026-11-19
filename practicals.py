# BU-CSC 313: Object-Oriented Programming practicals
# Author: Adeboye Adeyanju Oluwaferanmi

# Practical 1
print("Welcome to BU-CSC 313: Object oriented programming!")
print("Today, I am learning to model problems using objects and classes.")


# Practical 2: creating classes and objects
class Student:
    pass

student1 = Student()
student2 = Student()

print(type(student1))
print(type(student2))
print(student1 is student2)  # False: two separate objects


# Practical 3: adding attributes to objects
student1 = Student()
student1.name = "Ada"
student1.reg_no = "BU/CSC/001"
student1.programme = "Computer Science"

student2 = Student()
student2.name = "Tunde"
student2.reg_no = "BU/CSC/002"
student2.programme = "Computer Science"

print(student1.name, student1.reg_no)
print(student2.name, student2.reg_no)
