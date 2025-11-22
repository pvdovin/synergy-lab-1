# Базовый класс
class Vehicle:
    def __init__(self, brand):
        self.brand = brand

    def move(self):
        print(f"{self.brand}: Транспортное средство движется.")

    def description(self):
        print(f"Марка: {self.brand}")

# Производный класс
class Bicycle(Vehicle):
    def __init__(self, brand, gear_count):
        super().__init__(brand)
        self.gear_count = gear_count

    # Переопределение метода move
    def move(self):
        print(f"{self.brand}: Велосипед едет на {self.gear_count} передачах.")

    # Новый метод производного класса
    def show_gears(self):
        print(f"Количество передач: {self.gear_count}")

# Тестовая программа
if __name__ == "__main__":
    car = Vehicle("Toyota")
    car.description()
    car.move()

    print("---")

    bike = Bicycle("Stels", 21)
    bike.description()     # базовый метод
    bike.move()            # переопределенный метод
    bike.show_gears()      # уникальный метод производного класса