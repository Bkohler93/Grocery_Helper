import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

mixin SQLite {
  static Future<void> createTables(sql.Database db) async {
    await db.execute("""CREATE TABLE sections(
      priority INTEGER,
      name TEXT NOT NULL UNIQUE
    )""");
    await db.execute("""
    CREATE TRIGGER auto_increment_trigger
    AFTER INSERT ON sections
    WHEN new.priority IS NULL
    BEGIN
        UPDATE sections
        SET priority = (SELECT IFNULL(MAX(priority), 0) + 1 FROM sections)
        WHERE rowid = new.rowid;
    END;
    fdsafdsfsda
    """);
    await db.execute("""CREATE TABLE meals(
      name TEXT NOT NULL UNIQUE,
      checked INTEGER NOT NULL
      )
      """);
    await db.execute("""CREATE TABLE ingredients(
        name TEXT NOT NULL UNIQUE,
        category TEXT
      )
      """);
    await db.execute("""
      CREATE TABLE meal_ingredients(
        meal_id INTEGER NOT NULL, 
        ingredient_id INTEGER NOT NULL, 
        qty TEXT,
        qty_unit TEXT,
        FOREIGN KEY (meal_id) REFERENCES meals (rowid) 
          ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients (rowid)
          ON DELETE NO ACTION ON UPDATE NO ACTION
      )""");
    await db.execute("""
      CREATE TABLE shopping_list(
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        checked INTEGER NOT NULL,
        qty TEXT,
        qty_unit TEXT
      )
    """);
  }

  static Future<void> fillTables(sql.Database db) async {
    await db.execute("""
      INSERT INTO sections(name) VALUES ("produce"), ("personal"), ("snacks"), ("candy"),("condiments"), ("canned"), ("grains"), ("pasta"), ("soup"), ("asian"), ("seasoning"), ("baking"), ("breakfast"), ("bulk"), ("deli"), ("meat"), ("beer"), ("dairy"), ("cold beverages"), ("frozen"), ("household"), ("mexican"), ("chips"), ("soda"), ("bakery"), ("wine"), ("bread"), ("other")
    """);
    await db.execute("""
      INSERT INTO meals(name, checked) 
      VALUES ("meatballs with bulgogi sauce", 0), ("lemon chicken stock", 1)
    """);

    await db.execute("""
      INSERT INTO ingredients(name, category) VALUES ("lemon", "produce"), ("ground beef", "meat"), ("bulgogi sauce", "asian"), ("chicken stock", "soup")
    """);

    await db.execute("""
      INSERT INTO meal_ingredients(meal_id, ingredient_id, qty, qty_unit) VALUES
        ((SELECT rowid from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT rowid from ingredients WHERE name="lemon"), "2", ""),
        ((SELECT rowid from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT rowid from ingredients WHERE name="ground beef"),"1", "lb"),
        ((SELECT rowid from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT rowid from ingredients WHERE name="bulgogi sauce"),"3","tsp"),
        ((SELECT rowid from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT rowid from ingredients WHERE name="chicken stock"),"1/2","cup"),
        ((SELECT rowid from meals WHERE name="lemon chicken stock"),
          (SELECT rowid from ingredients WHERE name="chicken stock"),"1/2","cup"),
        ((SELECT rowid from meals WHERE name="lemon chicken stock"),
          (SELECT rowid from ingredients WHERE name="lemon"),"1","")
    """);

    await db.execute("""
      INSERT INTO shopping_list(name, category, checked, qty, qty_unit) VALUES
      ('ground beef', 'meat', 0, '1', 'lb'), ('lemon', 'produce', 1, '2', "")
    """);
  }

  //retrieve database
  static Future<sql.Database> db() async {
    //sql.databaseFactory.deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'grocery.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await fillTables(database);
      },
    );
  }

  static sql.ConflictAlgorithm get conflictAlgorithmReplace {
    return sql.ConflictAlgorithm.replace;
  }

  static sql.ConflictAlgorithm get conflictAlgorithmAbort {
    return sql.ConflictAlgorithm.abort;
  }
}
