list1 = ['0','1','2' ];
list2 = ['a','b','c' ];
list3 = list(zip( list1, list2 ));#[('0','a'),('1','b'),('2','c')]
(list1,list2) = zip(*list3);
