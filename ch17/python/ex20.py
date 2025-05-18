class person(object):
  def __init__(self, initial_age=0, initial_name="Jane Doe"):
    self.age  = initial_age;
    self.name = initial_name;
  def __del__(self):
    print("Yer killing me man");
  def __str__(self):
    return "name is " + self.name + "\n" +\
           "age  is " + str( self.age );
  def birthday(self):
    self.age += 1;
  def __getattr__(self, name ):
    return self.__dict__["my_"+name];# So rename all attributes my_name
  def __setattr__(self, name, value ):
    self.__dict__["my_"+name] = value;
    print name + " is now " + str( value );
import person;
kid = person( initial_age=1, initial_name = "Bob Smith" );
kid.birthday();
print( kid.age ) ; # "2"
