// lib/utils/menu_data.dart

import '../models/menu_item.dart';

class MenuData {
  static List<MenuItem> get allItems => [
    ...vegPizzas, ...specialPizzas, ...burgers, ...pastas,
    ...shakes, ...wraps, ...fries, ...sandwiches,
    ...tacos, ...snacks, ...garlicItems, ...meals,
  ];

  // ── VEG PIZZAS ──────────────────────────────────────────────
  static List<MenuItem> get vegPizzas => [
    MenuItem(id:'vp1',  name:'Margherita',       description:'Classic tomato sauce with cheese',                prices:{'regular':100,'medium':220,'large':350}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🍕', isBestseller:true),
    MenuItem(id:'vp2',  name:'Mushroom Loaded',  description:'Loaded with fresh mushrooms',                    prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🍄'),
    MenuItem(id:'vp3',  name:'Paneer Loaded',    description:'Loaded with fresh paneer',                       prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🧀'),
    MenuItem(id:'vp4',  name:'Veg Crunch',       description:'Onion + Capsicum + Paneer',                      prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🥗'),
    MenuItem(id:'vp5',  name:'Spring Fling',     description:'Capsicum + Corn + Paneer',                       prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🌽'),
    MenuItem(id:'vp6',  name:'Country Side',     description:'Mushroom + Corn + Olives',                       prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🫒'),
    MenuItem(id:'vp7',  name:'Garden Delight',   description:'Onion + Capsicum + Tomatoes',                    prices:{'regular':120,'medium':250,'large':380}, category:MenuCategory.vegPizza, subCategory:'Silver', emoji:'🍅'),
    MenuItem(id:'vp8',  name:'Farm House',       description:'Onion + Capsicum + Tomato + Mushroom',           prices:{'regular':140,'medium':300,'large':430}, category:MenuCategory.vegPizza, subCategory:'Gold',   emoji:'🏡', isBestseller:true),
    MenuItem(id:'vp9',  name:'Veggie Lover',     description:'Onion + Olives + Capsicum + Paneer',             prices:{'regular':140,'medium':300,'large':430}, category:MenuCategory.vegPizza, subCategory:'Gold',   emoji:'🥬'),
    MenuItem(id:'vp10', name:'Burn To Hell',     description:'Capsicum + Jalapeno + Mushroom + Red Paprika',   prices:{'regular':140,'medium':300,'large':430}, category:MenuCategory.vegPizza, subCategory:'Gold',   emoji:'🌶️'),
    MenuItem(id:'vp11', name:'Country Special',  description:'Onion + Capsicum + Corn + Paneer',               prices:{'regular':140,'medium':300,'large':430}, category:MenuCategory.vegPizza, subCategory:'Gold',   emoji:'⭐'),
    MenuItem(id:'vp12', name:'Paneer Blast',     description:'Onion + Corn + Extra Paneer + Mushroom + Red Paprika', prices:{'regular':160,'medium':380,'large':500}, category:MenuCategory.vegPizza, subCategory:'Platinum', emoji:'💥'),
    MenuItem(id:'vp13', name:'Hot Passion',      description:'Onion + Capsicum + Jalapeno + Red Paprika + Hot Sauce', prices:{'regular':160,'medium':380,'large':500}, category:MenuCategory.vegPizza, subCategory:'Platinum', emoji:'🔥', isBestseller:true),
    MenuItem(id:'vp14', name:'Peri Peri Veg',   description:'Onion + Capsicum + Olives + Mushroom + Paneer + Peri Peri Sauce', prices:{'regular':160,'medium':380,'large':500}, category:MenuCategory.vegPizza, subCategory:'Platinum', emoji:'🌿'),
    MenuItem(id:'vp15', name:'Tandoori Veg',     description:'Onion + Corn + Mushroom + Paneer + Jalapeno + Tandoori Sauce', prices:{'regular':160,'medium':380,'large':500}, category:MenuCategory.vegPizza, subCategory:'Platinum', emoji:'🫶'),
    MenuItem(id:'vp16', name:'Achari Veg',       description:'Capsicum + Corn + Paneer + Red Paprika + Tomato + Achari Sauce', prices:{'regular':160,'medium':380,'large':500}, category:MenuCategory.vegPizza, subCategory:'Platinum', emoji:'🥒'),
  ];

  // ── SPECIAL PIZZAS ───────────────────────────────────────────
  static List<MenuItem> get specialPizzas => [
    MenuItem(id:'sp1', name:'Special Veg Pasta Pizza', description:'Onion + Capsicum + Corn + Olives + Mushroom + Pasta + Cheese', prices:{'regular':190,'medium':390,'large':550}, category:MenuCategory.special, subCategory:'Special', emoji:'🍝'),
    MenuItem(id:'sp2', name:'Heart Special',           description:'Onion + Capsicum + Olives + Paneer + Mushroom + Extra Cheese', prices:{'regular':220,'medium':460,'large':600}, category:MenuCategory.special, subCategory:'Lover Special', emoji:'❤️', isBestseller:true),
    MenuItem(id:'sp3', name:'Ultimate Pizza',          description:'Onion + Capsicum + Corn + Paneer + Mushroom + Olives + Red Paprika + Jalapeno + Extra Cheese + Peri Peri/Tandoori Sauce', prices:{'regular':240,'medium':480,'large':650}, category:MenuCategory.special, subCategory:'Ultimate', emoji:'👑', isBestseller:true),
    MenuItem(id:'sp4', name:'Double Mania – Onion+Paneer',    description:'Onion + Paneer',    prices:{'regular':89,'medium':200,'large':320}, category:MenuCategory.special, subCategory:'Mania', emoji:'🎯'),
    MenuItem(id:'sp5', name:'Double Mania – Onion+Capsicum',  description:'Onion + Capsicum',  prices:{'regular':89,'medium':200,'large':320}, category:MenuCategory.special, subCategory:'Mania', emoji:'🎯'),
    MenuItem(id:'sp6', name:'Double Mania – Corn+Tomato',     description:'Corn + Tomato',     prices:{'regular':89,'medium':200,'large':320}, category:MenuCategory.special, subCategory:'Mania', emoji:'🎯'),
    MenuItem(id:'sp7', name:'Double Mania – Jalapeno+Corn',   description:'Jalapeno + Corn',   prices:{'regular':89,'medium':200,'large':320}, category:MenuCategory.special, subCategory:'Mania', emoji:'🎯'),
    MenuItem(id:'sp8', name:'Double Pizza Mania Combo', description:'Special combo deal', price:340, category:MenuCategory.special, subCategory:'Mania', emoji:'🎉'),
    MenuItem(id:'sp9', name:'Single Pizza Mania Combo', description:'Single pizza combo', price:260, category:MenuCategory.special, subCategory:'Mania', emoji:'🎊'),
    MenuItem(id:'sp10',name:'Tomato Pizza Mania',   description:'Single topping tomato',    price:69, category:MenuCategory.special, subCategory:'Mania', emoji:'🍅'),
    MenuItem(id:'sp11',name:'Onion Pizza Mania',    description:'Single topping onion',     price:69, category:MenuCategory.special, subCategory:'Mania', emoji:'🧅'),
    MenuItem(id:'sp12',name:'Capsicum Pizza Mania', description:'Single topping capsicum',  price:69, category:MenuCategory.special, subCategory:'Mania', emoji:'🫑'),
    MenuItem(id:'sp13',name:'Corn Pizza Mania',     description:'Single topping corn',      price:69, category:MenuCategory.special, subCategory:'Mania', emoji:'🌽'),
  ];

  // ── BURGERS ──────────────────────────────────────────────────
  static List<MenuItem> get burgers => [
    MenuItem(id:'b1', name:'Aloo Tikki Burger',        price:40,  category:MenuCategory.burger, emoji:'🍔'),
    MenuItem(id:'b2', name:'Spicy Aloo Tikki Burger',  price:50,  category:MenuCategory.burger, emoji:'🌶️'),
    MenuItem(id:'b3', name:'Crunchy Burger',            price:60,  category:MenuCategory.burger, emoji:'🍔'),
    MenuItem(id:'b4', name:'Cheese Aloo Tikki Burger', price:60,  category:MenuCategory.burger, emoji:'🧀', isBestseller:true),
    MenuItem(id:'b5', name:'Veg Burger',                price:60,  category:MenuCategory.burger, emoji:'🥗'),
    MenuItem(id:'b6', name:'Spicy Veg Burger',          price:70,  category:MenuCategory.burger, emoji:'🌶️'),
    MenuItem(id:'b7', name:'Cheese Veg Burger',         price:80,  category:MenuCategory.burger, emoji:'🧀'),
    MenuItem(id:'b8', name:'Peri Peri Burger',          price:80,  category:MenuCategory.burger, emoji:'🔥'),
    MenuItem(id:'b9', name:'Cheese Peri Peri Burger',   price:90,  category:MenuCategory.burger, emoji:'🔥', isBestseller:true),
    MenuItem(id:'b10',name:'Burger of King',            price:120, category:MenuCategory.burger, emoji:'👑'),
  ];

  // ── PASTA ─────────────────────────────────────────────────────
  static List<MenuItem> get pastas => [
    MenuItem(id:'pa1',name:'White Sauce Pasta', prices:{'regular':80,'large':150}, category:MenuCategory.pasta, emoji:'🍝'),
    MenuItem(id:'pa2',name:'Red Sauce Pasta',   prices:{'regular':80,'large':150}, category:MenuCategory.pasta, emoji:'🍝', isBestseller:true),
    MenuItem(id:'pa3',name:'Mix Sauce Pasta',   prices:{'regular':80,'large':150}, category:MenuCategory.pasta, emoji:'🍝'),
    MenuItem(id:'pa4',name:'Tandoori Pasta',    prices:{'regular':100,'large':190},category:MenuCategory.pasta, emoji:'🔥'),
    MenuItem(id:'pa5',name:'Ultimate Pasta',    prices:{'regular':120,'large':230},category:MenuCategory.pasta, emoji:'👑'),
  ];

  // ── SHAKES / COFFEE / MOJITO ──────────────────────────────────
  static List<MenuItem> get shakes => [
    MenuItem(id:'sh1', name:'Hot Coffee',           price:40, category:MenuCategory.shakes, emoji:'☕'),
    MenuItem(id:'sh2', name:'Cold Coffee',           price:80, category:MenuCategory.shakes, emoji:'🧋'),
    MenuItem(id:'sh3', name:'Chocolate Cold Coffee', price:80, category:MenuCategory.shakes, emoji:'🍫', isBestseller:true),
    MenuItem(id:'sh4', name:'Vanilla Shake',         price:80, category:MenuCategory.shakes, emoji:'🍦'),
    MenuItem(id:'sh5', name:'Strawberry Shake',      price:80, category:MenuCategory.shakes, emoji:'🍓'),
    MenuItem(id:'sh6', name:'Butter Scotch Shake',   price:80, category:MenuCategory.shakes, emoji:'🧁'),
    MenuItem(id:'sh7', name:'Oreo Shake',            price:80, category:MenuCategory.shakes, emoji:'🍪'),
    MenuItem(id:'sh8', name:'Chocolate Shake',       price:80, category:MenuCategory.shakes, emoji:'🍫'),
    MenuItem(id:'sh9', name:'Mojito',                price:80, category:MenuCategory.shakes, emoji:'🍹'),
    MenuItem(id:'sh10',name:'Masala Lemon',          price:80, category:MenuCategory.shakes, emoji:'🍋'),
    MenuItem(id:'sh11',name:'Blueberry Shake',       price:80, category:MenuCategory.shakes, emoji:'🫐'),
    MenuItem(id:'sh12',name:'Choco Lava Cake',       price:70, category:MenuCategory.shakes, emoji:'🎂', isBestseller:true),
  ];

  // ── WRAPS ─────────────────────────────────────────────────────
  static List<MenuItem> get wraps => [
    MenuItem(id:'w1',name:'Veg Wrap',         description:'Onion + Capsicum + Corn',                   price:60,  category:MenuCategory.wraps, emoji:'🌯'),
    MenuItem(id:'w2',name:'Aloo Tikki Wrap',  description:'Onion + Aloo Tikki + Corn',                 price:70,  category:MenuCategory.wraps, emoji:'🌯'),
    MenuItem(id:'w3',name:'Paneer Wrap',      description:'Onion + Corn + Paneer',                     price:80,  category:MenuCategory.wraps, emoji:'🌯'),
    MenuItem(id:'w4',name:'Farmhouse Wrap',   description:'Onion + Corn + Tomato + Mushroom',          price:90,  category:MenuCategory.wraps, emoji:'🌯'),
    MenuItem(id:'w5',name:'City Special Wrap',description:'Onion + Capsicum + Paneer + Mushroom',      price:100, category:MenuCategory.wraps, emoji:'⭐', isBestseller:true),
    MenuItem(id:'w6',name:'Cheese Wrap',      description:'Onion + Paneer + Mushroom + Corn + Cheese', price:120, category:MenuCategory.wraps, emoji:'🧀'),
    MenuItem(id:'w7',name:'Ultimate Wrap',    description:'Onion + Capsicum + Corn + Paneer Tikki + Mushroom + Cheese', price:150, category:MenuCategory.wraps, emoji:'👑'),
  ];

  // ── FRIES ─────────────────────────────────────────────────────
  static List<MenuItem> get fries => [
    MenuItem(id:'f1',name:'Plain Fries',    prices:{'regular':40,'medium':60,'large':110}, category:MenuCategory.fries, emoji:'🍟'),
    MenuItem(id:'f2',name:'Peri Peri Fries',prices:{'regular':50,'medium':80,'large':150}, category:MenuCategory.fries, emoji:'🌶️', isBestseller:true),
    MenuItem(id:'f3',name:'Creamy Fries',   prices:{'regular':50,'medium':80,'large':150}, category:MenuCategory.fries, emoji:'🍟'),
    MenuItem(id:'f4',name:'Tandoori Fries', prices:{'regular':50,'medium':80,'large':150}, category:MenuCategory.fries, emoji:'🔥'),
    MenuItem(id:'f5',name:'Mix Sauce Fries',prices:{'regular':60,'medium':90,'large':170}, category:MenuCategory.fries, emoji:'🍟'),
    MenuItem(id:'f6',name:'Masala Fries',   prices:{'regular':50,'medium':80,'large':150}, category:MenuCategory.fries, emoji:'✨'),
  ];

  // ── SANDWICHES ────────────────────────────────────────────────
  static List<MenuItem> get sandwiches => [
    MenuItem(id:'sa1',name:'Cold Sandwich',          price:50,  category:MenuCategory.sandwich, emoji:'🥪'),
    MenuItem(id:'sa2',name:'Veg Grilled Sandwich',   description:'Onion + Corn + Capsicum',               price:60,  category:MenuCategory.sandwich, emoji:'🥪'),
    MenuItem(id:'sa3',name:'Hot Sandwich',            description:'Onion + Corn + Jalapeno + Hot Sauce',   price:70,  category:MenuCategory.sandwich, emoji:'🌶️'),
    MenuItem(id:'sa4',name:'Paneer Grilled Sandwich', description:'Onion + Corn + Paneer',                 price:80,  category:MenuCategory.sandwich, emoji:'🥪', isBestseller:true),
    MenuItem(id:'sa5',name:'Farmhouse Sandwich',      description:'Onion + Corn + Tomato + Mushroom',      price:90,  category:MenuCategory.sandwich, emoji:'🏡'),
    MenuItem(id:'sa6',name:'City Special Sandwich',   description:'Onion + Capsicum + Paneer + Mushroom',  price:100, category:MenuCategory.sandwich, emoji:'⭐'),
    MenuItem(id:'sa7',name:'Cheese Sandwich',         description:'Onion + Paneer + Mushroom + Corn + Cheese', price:110, category:MenuCategory.sandwich, emoji:'🧀'),
    MenuItem(id:'sa8',name:'Ultimate Sandwich',       description:'Onion + Paneer + Mushroom + Corn + Cheese + Peri Peri Sauce', price:120, category:MenuCategory.sandwich, emoji:'👑'),
  ];

  // ── TACOS ─────────────────────────────────────────────────────
  static List<MenuItem> get tacos => [
    MenuItem(id:'t1',name:'Veg Taco',         description:'Corn + Paneer',                       price:80,  category:MenuCategory.tacos, emoji:'🌮'),
    MenuItem(id:'t2',name:'Farm Yard Taco',   description:'Onion + Capsicum + Mushroom',         price:90,  category:MenuCategory.tacos, emoji:'🌮'),
    MenuItem(id:'t3',name:'City Special Taco',description:'Onion + Capsicum + Paneer + Mushroom',price:100, category:MenuCategory.tacos, emoji:'🌮', isBestseller:true),
    MenuItem(id:'t4',name:'Cheese Taco',      description:'Onion + Paneer + Corn + Mushroom + Cheese', price:120, category:MenuCategory.tacos, emoji:'🧀'),
    MenuItem(id:'t5',name:'Ultimate Taco',    description:'Onion + Corn + Paneer Tikki + Mushroom + Cheese', price:150, category:MenuCategory.tacos, emoji:'👑'),
  ];

  // ── SNACKS ────────────────────────────────────────────────────
  static List<MenuItem> get snacks => [
    MenuItem(id:'sn1',name:'Potato Pops',   price:100, category:MenuCategory.snacks, emoji:'🥔'),
    MenuItem(id:'sn2',name:'Veg Fries',     price:100, category:MenuCategory.snacks, emoji:'🍟'),
    MenuItem(id:'sn3',name:'Paneer Salad',  prices:{'regular':90,'large':170}, category:MenuCategory.snacks, emoji:'🥗'),
    MenuItem(id:'sn4',name:'Crunchy Salad', prices:{'regular':100,'large':190},category:MenuCategory.snacks, emoji:'🥗'),
  ];

  // ── GARLIC ────────────────────────────────────────────────────
  static List<MenuItem> get garlicItems => [
    MenuItem(id:'g1',name:'Cheese Garlic Stick',         price:90,  category:MenuCategory.garlic, emoji:'🧄'),
    MenuItem(id:'g2',name:'Stuffed Garlic Bread',        description:'Corn + Jalapeno + Cheese',             price:90,  category:MenuCategory.garlic, emoji:'🍞', isBestseller:true),
    MenuItem(id:'g3',name:'Ultimate Stuffed Garlic Bread',description:'Corn + Paneer + Extra Cheese',        price:110, category:MenuCategory.garlic, emoji:'👑'),
    MenuItem(id:'g4',name:'Veg Loaded Garlic Bread',     description:'Onion + Capsicum + Red Paprika + Corn + Cheese', price:130, category:MenuCategory.garlic, emoji:'🥦'),
    MenuItem(id:'g5',name:'Zingy Parcel',                price:50,  category:MenuCategory.garlic, emoji:'📦'),
    MenuItem(id:'g6',name:'Paneer Zingy Parcel',         price:70,  category:MenuCategory.garlic, emoji:'📦'),
  ];

  // ── MEALS ─────────────────────────────────────────────────────
  static List<MenuItem> get meals => [
    MenuItem(id:'m1',name:'Meals-1',description:'1 Cheese Aloo Tikki Burger + Plain Fries Small + 250ml Coke',                            price:110, category:MenuCategory.meals, emoji:'🎁'),
    MenuItem(id:'m2',name:'Meals-2',description:'Veg Crunch Small Pizza + Cheese Taco + 250ml Coke',                                       price:240, category:MenuCategory.meals, emoji:'🎁', isBestseller:true),
    MenuItem(id:'m3',name:'Meals-3',description:'Spring Fling Small Pizza + Pasta + Oreo Shake',                                           price:260, category:MenuCategory.meals, emoji:'🎁'),
    MenuItem(id:'m4',name:'Meals-4',description:'Veg Crunch Medium Pizza + Ultimate Stuffed Garlic Bread + Coke MRP 50/-',                 price:370, category:MenuCategory.meals, emoji:'🎁'),
    MenuItem(id:'m5',name:'Meals-5',description:'Peri-Peri Veg Large Pizza + Choco Lava Cake + Paneer Grill Sandwich + Coke 2 Ltr',        price:680, category:MenuCategory.meals, emoji:'🎁', isBestseller:true),
  ];
}
