// Isaiah Harville
// 4/5/2024
// Recreating LAB 3 in C/C++
//  g++ -o LAB5 LAB_5.cpp

#include <iostream>
#include <vector>
#include <string>

// Globals 
std::vector<int> drink_inventory = {2, 2, 2, 2};
int total_money;
int input_money = 0;
int selected_drink = 0;
char confirm_input;

void get_money();
void select_drink();
void check_stock(int choice);
void display_inventory(int total_money);

int main() {
    std::cout << "\nSELECT DRINK '6' TO SEE INVENTORY\n\nWelcome to The Vending Machine\n";
    get_money();
}

void get_money() {
    int inserted_money = 0;
    while (total_money < 55) {
        std::cout << std::endl << "\nInsert change (5, 10, 25, 100): ";
        std::cin >> input_money;
        if (input_money == 5 || input_money == 10 || input_money == 25 || input_money == 100) {
            total_money += input_money;
            std::cout << std::endl << "Total is " << total_money << " cents." << std::endl;
            if (total_money >= 55) break;
        } 
        else if (input_money == 6) { display_inventory(total_money); }
        else {
            std::cout << std::endl << "Invalid selection. Please try again.\n" << std::endl;
        }
    }
    select_drink();
}

void select_drink() {
    int choice;
    std::cout << "\nSelect a drink (55c):\n1. Coke\n2. Sprite\n3. Dr. Pepper\n4. Coke Zero\n5. Exit\nEnter choice: ";
    std::cin >> choice;

    std::cout << std::endl << "You selected " << choice << " is this correct? (y/n)" << std::endl;
    std::cin >> confirm_input;
    
    if (confirm_input == 'y') { 
        if (choice == 5) {
            std::cout << std::endl << "Goodbye!" << std::endl;
            exit(1);
        } else if (choice == 6) {
            display_inventory(total_money);
        } else if (choice < 1 || choice > 6) {
            std::cout << std::endl << "Invalid selection. Please try again." << std::endl;
            select_drink();
        } else { check_stock(choice); }
    } else { select_drink(); }

}

void check_stock(int choice) {
    if (drink_inventory[choice - 1] > 0) {
        drink_inventory[choice - 1]--;
        total_money -= 55;
        std::cout << "\nSelection " << choice << " has been dispensed with " << total_money << " change." << std::endl;
        total_money = 0;
        get_money();
    } else {
        std::cout << std::endl << "Sorry! Your selection is out of stock.\n\n";
        select_drink();
    }
}

void display_inventory(int total_money) {
    std::cout << "\nDRINK  SUPPLY\n";
    for (int i = 0; i < drink_inventory.size(); ++i) {
        std::cout << "  " << (i + 1) << "\t " << drink_inventory[i] << std::endl;
    }
    if (total_money == 0) { get_money(); }
    else { select_drink(); }
}
