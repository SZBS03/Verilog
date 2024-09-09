package ASSIGN2.task_1

object Ex_2 {

    def main(args: Array[String]): Unit = {

       val list1 : List[Char]= List('a', 'b', 'c')
       val list2 : List[Int] = List(3, 5, 7)

       val vMap = list1.zip(list2)
       val rMap = vMap.zipWithIndex

       val fx = rMap.map{ case ((_,value),_) => value}
       val mean = fx.sum.toDouble/fx.size
       val r_fx = rMap.map{case ((char,_),index) => ((char,mean),index) }

       println(vMap)
       println(rMap)
       println(r_fx)


     }
}
