class main( object ):
  def __init__(self):
    self.foo = 1;
    self.bar = 2;
    result = add( self );
    return result;
def add( self ):
  rts = self.foo + self.bar;
  return rts;
main = main();
