local firstnameBoys = {
  american = [],
  british = [],
  chinese = [],
  french = [],
  german = [],
  italian = [],
  irish = [],
  jewish = [],
  mexican = [],
}

local firstnameGirls = {
  american = [],
  british = [],
  chinese = ["Ai", "Bi", "Cai", "Dan", "Fang", "Hong", "Juan", "Lan", "Li", "Li", "Lian", "Na", "Ni", "Qian", "Qiong", "Shan", "Shu", "Ting", "Xia", "Xian", "Yun", "Zhen"],
  french = [],
  german = ["Amelie", "Andrea", "Angelika", "Anna", "Hannah", "Christina", "Elke", "Emma", "Erika", "Gisela", "Emily", "Ilse", "Johanna", "Katrin", "Mia", "Maria", "Martina", "Melanie", "Nadine", "Nicole", "Petra", "Sabine", "Sabrina", "Sandra", "Stefanie"],
  italian = [],
  irish = ["Grace", "Ciara", "Fiona", "Nessa", "Cara", "Shauna", "Nuala", "Emily", "Emma", "Ava", "Sophie", "Amelia", "Ella", "Lucy"],
  jewish = [],
  mexican = ["Maria", "Guadalupe", "Juana", "Margarita", "Josefina", "Veronica", "Leticia", "Rosa", "Francisca", "Teresa", "Alicia", "Alejandra", "Martha", "Yolanda", "Patricia", "Gabriela", "Antonia", "Isabel", "Irma", "Lucia", "Adriana"],
}

local lastname = {
  american = ["Smith", "Johnson", "Miller", "Brown", "Jones", "Williams", "Davis", "Anderson", "Wilson", "Martin", "Taylor", "Moore", "Thompson", "White", "Clark", "Thomas", "Hall", "Baker", "Nelson", "Allen", "Harris", "King", "Adams", "Walker", "Wright", "Roberts", "Campbell", "Jackson", "Phillips", "Hill", "Scott", "Robinson", "Murphy", "Cook", "Green", "Lee", "Evans", "Peterson", "Morris", "Collins", "Mitchell", "Parker", "Rogers", "Stewart", "Turner", "Wood", "Carter", "Morgan", "Cox", "Kelly", "Edwards", "Bailey", "Ward", "Reed", "Myers", "Sullivan", "Cooper", "Bennett", "Long", "Fisher", "Russell", "Howard", "Gray", "Bell", "Foster", "Ross", "Olson", "Richardson", "Powell", "Stevens", "Brooks", "Perry", "West", "Cole", "Barnes", "Hamilton", "Graham", "Murray", "Wallace", "Butler", "Simmons", "Warren", "Hicks", "Henry", "Duncan", "Woods", "Richards", "Ray", "Bishop", "Morrison", "Lee"],
  british = [],
  chinese = ["Wang", "Li", "Zhang", "Liu", "Chen", "Yang", "Huang", "Zhao", "Wu", "Zhou", "Wong", "Lin", "Pham", "Chang", "Huang", "Khan", "Shan", "Yu", "Choi", "Vang", "Ho", "Xiong", "Vu", "Vo", "Lim", "Lu", "Tan", "Cheng", "Hong", "Xu", "Duong", "Lau", "Yee", "Fong", "Su", "Chong", "Dong", "Thai", "Feng", "Luo", "Tu", "Liao"],
  french = [],
  german = ["Muller", "Schmidt", "Schneider", "Fischer", "Weber", "Meyer", "Wagner", "Becker", "Schulz", "Hoffmann", "Schafer", "Koch", "Bauer", "Richter", "Klein", "Wolf", "Schroder", "Neumann", "Schwarz", "Zimmermann", "Braun", "Kruger", "Hofmann", "Hartmann", "Lange", "Schmitt", "Werner", "Schmitz", "Krause", "Meier", "Lehmann", "Schmid", "Schulze", "Maier", "Kohler", "Herrmann", "Konig", "Walter", "Mayer", "Huber", "Kaiser", "Fuchs", "Peters", "Lang", "Scholz", "Moller", "Jung", "Hahn", "Schubert", "Vogel", "Keller", "Gunther", "Frank", "Berger", "Winkler", "Roth", "Beck", "Lorenz", "Baumann", "Franke", "Albrecht", "Schuster", "Bohm", "Kraus", "Martin", "Kramer", "Vogt", "Stein", "Jager", "Otto", "Sommer", "Heinrich", "Brandt", "Haas", "Schreiber", "Graf", "Schulte", "Dietrich", "Ziegler", "Kuhn", "Pohl", "Engel", "Horn", "Busch", "Bergmann", "Thomas", "Voigt", "Sauer", "Wolff"],
  italian = ["Accardi", "Agosti", "Amato", "Barone", "Bernardi", "Bianco", "Bruni", "Bruno", "Caputo", "Carbone", "Caruso", "Cattaneo", "Colombo", "Conte", "Coppola", "Costa", "DeVille", "Donato", "Esposito", "Farina", "Fiore", "Fontana", "Gallo", "Gatti", "Gentile", "Giordano", "Grasso", "Greco", "Guerra", "Lombardi", "Mancini", "Marchetti", "Mariano", "Marino", "Monti", "Moretti", "Pellegrini", "Rabito", "Ricci", "Rossi", "Santoro", "Scotti", "Serra", "Testa", "Verga", "Zucca"],
  irish = ["Murphy", "Kelly", "O'Sullivan", "Walsh", "Smith", "O'Brien", "Byrne", "Ryan", "O'Connor", "O'Neill", "O'Reilly", "Doyle", "McCarthy", "Gallagher", "O'Doherty", "Kennedy", "Lynch", "Murray", "Quinn", "Moore", "McLoughlin", "O'Carroll", "Connolly", "Daly", "O'Connell", "Wilson", "Dunne", "Brennan", "Burke", "Collins", "Campbell", "Clarke", "Johnston", "Hughes", "O'Farrell", "Fitzgerald", "Brown", "Martin", "Maguire", "Nolan"],
  jewish = ["Aberman", "Almen", "Appelbaum", "Berkman", "Berman", "Bingham", "Brafman", "Braverman", "Dorman", "Fangman", "Feingold", "Fishel", "Giller", "Gitelman", "Hendel", "Himmelman", "Hyams", "Kallus", "Kamber", "Kimelman", "Kuperman", "Latter", "Leiman", "Lipman", "Oshman", "Seeman", "Tenenbaum", "Weinbaum", "Wollman"],
  mexican = ["Rodriguez", "Hernandez", "Martinez", "Garcia", "Gonzalez", "Lopez", "Ramirez", "Sanchez", "Perez", "Flores", "Chavez", "Ruiz", "Romero", "Castro", "Soto", "Reyes", "Cruz", "Garza", "Torres", "Gomez", "Resendiz", "Morales", "Jimenez", "Santiago", "Vazquez", "Diaz", "Benitez", "Acosta", "Herrera", "Molina", "Aguirre", "Rojas", "Ortiz", "Vera", "Moreno", "Castillo", "Arias", "Mendez", "Rivera", "Mendoza", "Medina", "Rios", "Vargas", "Valdez", "Ortega", "Espinoza", "Juarez", "Rivas", "Ramos"],
}