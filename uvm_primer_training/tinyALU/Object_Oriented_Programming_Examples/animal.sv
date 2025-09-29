virtual class animal;
    int age = 1;
    string name = "x";

    function new(int a, string n);
        age = a;
        name = n;
    endfunction : new

    pure virtual function void makesound();

    function string get_name();
        return name;
    endfunction : get_name
endclass : animal

class lion extends animal;
    function new(int age, string name);
        super.new(age, name);    
    endfunction : new

    function void makesound();
        $display("The Lion says Roar!");
    endfunction : makesound
endclass : lion 

class chicken extends animal;
    function new(int age, string name);
        super.new(age, name);    
    endfunction : new

    function void makesound();
        $display("The chicken says kakaw!");
    endfunction : makesound
endclass : chicken

class animal_cage #(type t, string TYPE_NAME = "UNKNOWN");
    protected static t cage[$];

    static function void cage_animal(t l);
        cage.push_back(l);
    endfunction : cage_animal

    static function void display_animals();
        $display("%s's cage contains: ", TYPE_NAME);
        foreach (cage[i]) begin
            $display(cage[i].get_name());
            $display(cage[i].age); end
    endfunction : display_animals
endclass : animal_cage

module animals;
    lion lion_h;
    chicken chicken_h;
    animal animal_h;
    animal_cage #(lion,"lion") lion_cage;
    animal_cage #(chicken,"chicken") chicken_cage;
    initial begin
        lion_h = new(2, "kimba");
        lion_cage.cage_animal(lion_h);
        lion_h = new(4, "simba");
        lion_cage.cage_animal(lion_h);
        lion_h = new(6, "mufasa");
        lion_cage.cage_animal(lion_h);

        chicken_h = new(0.4, "kakora");
        chicken_cage.cage_animal(chicken_h);
        chicken_h = new(0.5, "shajar");
        chicken_cage.cage_animal(chicken_h);
        chicken_h = new(0.8, "namrood");
        chicken_cage.cage_animal(chicken_h);

        lion_cage.display_animals();
        chicken_cage.display_animals();
    end
endmodule
