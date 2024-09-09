package ASSIGN2.task_1

object Ex_4 {

  //11.02
  def main(args: Array[String]): Unit = {
    val ulist = List(1, 2, 3, 4, 5)
    val u_listtwice = ulist.map(_* 2)
    println(s"List elements doubled - $u_listtwice")

    def f(x: Int) = if (x > 2) x * x
    else None

    val ulist_squared = ulist.map(f(_))
    println(s"List elements squared selectively - $ulist_squared")

    //11.03
    val u_list : List[Int] = List(1,2,3,4,5)
    def g(v:Int)= List(v-1,v,v+1)
    val ulist_extended = u_list.map(g(_))
    println(s"Extended - $ulist_extended ")
    val ulist_extended_flatmap = u_list.flatMap(g(_))
    println(s"Extended - $ulist_extended_flatmap ")

    //11.04
   val Ulist : List[Int] = List(1,2,3,4,5)

    def p(x: Int) = if (x>2) Some(x) else None
    val Ulist_selective = Ulist.map(p(_))
    println((s"Selective elements of list with map - $Ulist_selective"))

    val Ulist_selective_flatmap = Ulist.flatMap(p(_))
    println(s"Selective elements of List with flatmap - $Ulist_selective_flatmap")

  }
}