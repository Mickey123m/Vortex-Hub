local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local palavrasPT = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Ao", "Ar", "As", "At", "Ah", "Ai", "Al", "Am", "An",
        "Da", "De", "Di", "Do", "Du", "Em", "Eu", "Ex", "Eh", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Fim", "Ha", "He", "Hi", "Ho", "Hu",
        "Ia", "Io", "Ir", "Is", "It", "Iu", "Ja", "Je", "Ji", "Jo", "Ju",
        "Ka", "Ke", "Ki", "Ko", "Ku", "La", "Le", "Li", "Lo", "Lu", "Lua",
        "Ma", "Me", "Mi", "Mo", "Mu", "Mar", "Mao", "Mel", "Mau",
        "Na", "Ne", "Ni", "No", "Nu", "Nao", "Nos",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Paz", "Pau", "Pe",
        "Ra", "Re", "Ri", "Ro", "Ru", "Rua", "Rio", "Ria",
        "Sa", "Se", "Si", "So", "Su", "Sol", "Sim", "Sou", "Sal",
        "Ta", "Te", "Ti", "To", "Tu", "Tal", "Tao",
        "Ua", "Ui", "Um", "Uns", "Uma", "Umas", "Ur",
        "Va", "Ve", "Vi", "Vo", "Vu", "Vai", "Vem", "Viu", "Vos",
        "Xa", "Xe", "Xi", "Xo", "Xu", "Xis",
        "Za", "Ze", "Zi", "Zo", "Zu"
    },
    ["COMPLETAS"] = {
        "Amor", "Amigo", "Agua", "Arvore", "Abacate", "Alegria", "Animal", "Anjo", "Alma", "Ave", "Ato", "Amante", "Aluno", "Aluna", "Aula", "Alto", "Antes", "Assim", "Ano", "Amo", "Ama", "Areia", "Azeitona",
        "Bola", "Boneca", "Bala", "Bolo", "Bebe", "Boca", "Braco", "Branco", "Bomba", "Brisa", "Beleza", "Batata", "Banana", "Bicicleta", "Boi", "Bau", "Bem", "Bom",
        "Casa", "Carro", "Cama", "Cachorro", "Ceu", "Copo", "Carta", "Cinto", "Cego", "Coxa", "Cor", "Cadeira", "Cavalo", "Cobra", "Cozinha", "Cao", "Com", "Cem",
        "Chave", "Chuva", "Chao", "Chama", "Chocolate", "Choro", "Chumbo", "Chique", "Chinelo", "Charme", "Churrasco", "Chaveiro", "Chamine", "Chiclete",
        "Dado", "Dedo", "Doce", "Dente", "Dia", "Deus", "Danca", "Dor", "Duna", "Dica", "Dom", "Dinheiro", "Diamante", "Duvida", "Dar", "Dez",
        "Escola", "Estrela", "Elefante", "Escada", "Emo", "Erva", "Eixo", "Eco", "Etica", "Era", "Esperanca", "Espada", "Espelho", "Estrada", "Ela", "Ele", "Eles", "Elas",
        "Faca", "Festa", "Fogo", "Flor", "Frio", "Fome", "Forte", "Fe", "Fuga", "Fase", "Fim", "Fazenda", "Foguete", "Fronteira", "Foz", "Fez",
        "Gato", "Gelo", "Gota", "Gol", "Grande", "Grato", "Gente", "Grito", "Grama", "Gula", "Garfo", "Garagem", "Gaveta", "Girassol", "Gas",
        "Hora", "Hotel", "Hino", "Habilidade", "Harpa", "Haste", "Hiena", "Humor", "Homem", "Honra",
        "Igreja", "Ilha", "Ima", "Inseto", "Idade", "Idolo", "Irado", "Impar", "Indio", "Irmao", "Irma", "Ir", "Ia", "Iate", "Iara",
        "Janela", "Jogo", "Jato", "Joia", "Jovem", "Junto", "Janta", "Jaz", "Juba", "Jardim", "Jornal", "Jogador", "Jus",
        "Kaki", "Karma", "Kart", "Kebab", "Ketchup", "Kilo", "Kit", "Kiwi", "Kaiser", "Karaoke", "Karate", "Kayak", "Kimono", "Kiosque", "Koala", "Kombi",
        "Lata", "Leao", "Lua", "Livro", "Lindo", "Largo", "Leite", "Lousa", "Lince", "Lixo", "Laranja", "Limao", "Luzes", "Luz", "Ler", "Leu",
        "Mala", "Mao", "Mesa", "Moto", "Mundo", "Morto", "Muito", "Monge", "Mamilo", "Moca", "Macaco", "Madeira", "Mochila", "Moeda", "Mas", "Meu", "Meus",
        "Nada", "Nave", "Ninho", "Nove", "Noite", "Nobre", "Norte", "Nexo", "Nata", "Nuca", "Navio", "Noticia", "Novela", "Nem", "Num",
        "Ovo", "Olho", "Ouro", "Osso", "Ontem", "Ordem", "Oeste", "Oleo", "Onda", "Orgao", "Ovelha", "Oculos", "Orelha", "Onde",
        "Pato", "Peixe", "Pena", "Pote", "Porta", "Pedra", "Prato", "Presa", "Pombo", "Preto", "Palavra", "Pessoa", "Pequeno", "Problema", "Programa", "Presente", "Professor", "Pipoca", "Pirata", "Por", "Pos",
        "Queijo", "Quadro", "Quarto", "Quente", "Quase", "Querer", "Queda", "Queixo", "Quilo", "Quadrado", "Quarenta", "Quilometro", "Quintal", "Quinze", "Que", "Quem",
        "Rato", "Rede", "Rio", "Roda", "Roupa", "Rico", "Rapido", "Rima", "Roxo", "Rugby", "Relogio", "Remedio", "Riqueza", "Rir",
        "Sapo", "Sino", "Sol", "Suco", "Sala", "Santo", "Sorte", "Selva", "Seta", "Sim", "Sistema", "Semente", "Segredo", "Sentido", "Silencio", "Sorvete", "Sombra", "Saudade", "Sapato", "Ser", "Seu", "Seus",
        "Tatu", "Tela", "Teto", "Tigre", "Terra", "Tempo", "Tudo", "Trono", "Tora", "Tufo", "Trabalho", "Telefone", "Tamanho", "Tesoura", "Tomate", "Tenis", "Tigela", "Tartaruga", "Ter", "Teu", "Teus", "Tua", "Tuas",
        "Uva", "Urso", "Unha", "Uno", "Ultimo", "Unico", "Urgente", "Utero", "Urano",
        "Vaca", "Vela", "Vento", "Vidro", "Velho", "Verde", "Vida", "Vulcao", "Valsa", "Vulto", "Viagem", "Vizinho", "Vassoura", "Vestido", "Vez", "Ver",
        "Wafer", "Waffle", "Walkman", "Water", "Watt", "Web", "Weekend", "Western", "Whatsapp", "Whisky", "Wi-fi", "Windsurf", "Wok", "Workshop", "World", "Wow",
        "Xadrez", "Xarope", "Xerife", "Xerox", "Xicara", "Xingo", "Xixi", "Xodo", "Xucro",
        "Axe", "Exame", "Exato", "Exibir", "Existe", "Extra", "Maximo", "Proximo", "Taxa", "Texto", "Toxico", "Flexivel", "Complexo", "Conexao", "Nexo", "Sexo", "Anexo", "Reflexo",
        "Yakisoba", "Yakult", "Yamaha", "Yard", "Yen", "Yin", "Yoga", "Yogurt", "Youtube",
        "Zebra", "Zero", "Zangado", "Ziper", "Zona", "Zoo", "Zumbi",
        "Dia", "Diante", "Diabo", "Diadema", "Dialeto", "Diamante", "Diario",
        "Via", "Viagem", "Viado", "Viajante", "Viajar", "Viaduto",
        "Lia", "Liana", "Liar", "Ria", "Riacho", "Tia", "Tiara",
        "Pia", "Piano", "Piada", "Piar", "Mia", "Miami", "Miar",
        "Gia", "Giardia", "Fia", "Fiado", "Fiasco", "Cia", "Ciatica", "Cianeto",
        "Blusa", "Bloco", "Brasil", "Bravo", "Briga",
        "Claro", "Clima", "Clube", "Crianca", "Cristal", "Cruz", "Cruel",
        "Floresta", "Flauta", "Flecha", "Fracao", "Frasco", "Freio", "Frente",
        "Gloria", "Global", "Gluten", "Graca", "Grade", "Grao", "Grupo",
        "Plano", "Planta", "Placa", "Plastico", "Pleno", "Pluma", "Plural",
        "Praia", "Praca", "Preco", "Prego", "Preso", "Pronto",
        "Traco", "Trama", "Trator", "Treino", "Trigo", "Triste", "Trofeu",
        "Xenofobia", "Xereta", "Xerocar", "Xexeu", "Xifopago", "Xilogravura", "Ximango", "Xinxim", "Xiquexique", "Xiripiti",
        "Xampu", "Xale", "Xara", "Xavante", "Xerox", "Xingar", "Xisto", "Xucro",
        "Anexar", "Anexo", "Boxe", "Boxeador", "Complexo", "Conexao", "Convexo", "Cruxificar",
        "Exalar", "Exaltar", "Exame", "Examinar", "Exasperar", "Exaurir", "Exceder", "Excelente", "Excecao", "Excerto", "Excesso", "Excitar", "Excluir", "Exclama", "Excreta", "Excursao",
        "Executar", "Executor", "Exegese", "Exemplar", "Exemplo", "Exercer", "Exercito", "Exibir", "Exigir", "Exilio", "Eximir", "Existir", "Exito", "Exodo", "Exonerar", "Exorar", "Exotico",
        "Expandir", "Expedir", "Expelir", "Experto", "Expiar", "Expirar", "Explicar", "Explodir", "Explorar", "Export", "Expresso", "Exprimir", "Expulsar",
        "Extase", "Extender", "Extenso", "Exterior", "Externo", "Extinguir", "Extorsao", "Extrair", "Extremo", "Extroversao", "Exuberante", "Exultar", "Exumar",
        "Flexao", "Flexivel", "Flexor", "Hexagono", "Hexaedro", "Inflexivel", "Lexico", "Maxilar", "Maximo", "Maxixe",
        "Nexo", "Oxala", "Oxente", "Oxigenio", "Oxidar", "Paradoxo", "Perplexo", "Plexo", "Praxe", "Prefixar", "Prefixado", "Proximo", "Reflexo", "Reflexao",
        "Saxofone", "Sexo", "Sexual", "Silex", "Sintaxe", "Taxa", "Taxar", "Taxativo", "Texte", "Texto", "Textual", "Toxico", "Toxina", "Torax", "Xenon", "Xerife"
    }
}

local palavrasEN = {
    ["CURTAS"] = {
        "A", "I", "O", "Y", "Am", "An", "As", "At", "Ah", "Ai", "Al", "Ar", "Ax",
        "Be", "By", "Bo", "Bi", "Co", "Ca", "Ce", "Ci", "Cu",
        "Do", "Da", "De", "Di", "Du", "Em", "El", "Es", "Ex", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Go", "Ga", "Ge", "Gi", "Gu",
        "Ha", "He", "Hi", "Ho", "Hu", "If", "In", "Is", "It",
        "La", "Le", "Li", "Lo", "Lu", "Ma", "Me", "Mi", "Mo", "Mu", "My",
        "Na", "Ne", "Ni", "No", "Nu", "Of", "Oh", "Oi", "Ok", "On", "Or", "Os", "Ow", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Sh", "Si", "So", "St", "Su", "Ta", "Te", "Th", "Ti", "To", "Tu",
        "Um", "Un", "Up", "Us", "Va", "Ve", "Vi", "Vo", "Vu",
        "Wa", "We", "Wi", "Wo", "Wu", "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu"
    },
    ["COMPLETAS"] = {
        "Ace", "Act", "Add", "Age", "Ago", "Aid", "Aim", "Air", "All", "And", "Ant", "Any", "Ape", "Arc", "Are", "Ark", "Arm", "Art", "Ash", "Ask", "Ate", "Awe", "Axe",
        "Bad", "Bag", "Ban", "Bar", "Bat", "Bay", "Bed", "Bet", "Bid", "Big", "Bin", "Bit", "Bog", "Bow", "Box", "Boy", "Bud", "Bug", "Bun", "Bus", "But", "Buy",
        "Cab", "Cam", "Can", "Cap", "Car", "Cat", "Cop", "Cow", "Cry", "Cub", "Cup", "Cur", "Cut",
        "Dad", "Dam", "Day", "Den", "Dew", "Did", "Dig", "Dim", "Dip", "Dog", "Dot", "Dry", "Dug", "Duo", "Dye",
        "Ear", "Eat", "Eel", "Egg", "Elf", "Elm", "Emu", "End", "Era", "Eve", "Eye",
        "Fan", "Far", "Fat", "Fax", "Fed", "Few", "Fig", "Fin", "Fir", "Fit", "Fix", "Fly", "Fog", "For", "Fox", "Fry", "Fun", "Fur",
        "Gag", "Gap", "Gas", "Get", "Gig", "Gin", "God", "Got", "Gum", "Gun", "Gut", "Guy", "Gym",
        "Had", "Ham", "Has", "Hat", "Hay", "Hen", "Her", "Hew", "Hid", "Him", "Hip", "His", "Hit", "Hog", "Hop", "Hot", "How", "Hub", "Hue", "Hug", "Hum", "Hut",
        "Ice", "Ink", "Inn", "Ion", "Its", "Ivy",
        "Jab", "Jag", "Jam", "Jar", "Jaw", "Jay", "Jet", "Jig", "Job", "Jog", "Jot", "Joy", "Jug", "Jut",
        "Keg", "Ken", "Key", "Kid", "Kin", "Kit", "Kite", "Knee", "Knew", "Knit", "Knob", "Knot", "Know", "Keen", "Keep", "Kept", "Kick", "Kill", "Kind", "King", "Kiss",
        "Lab", "Lad", "Lag", "Lap", "Law", "Lay", "Led", "Leg", "Let", "Lid", "Lip", "Lit", "Log", "Lot", "Low",
        "Mad", "Man", "Map", "Mat", "Maw", "Men", "Met", "Mid", "Mix", "Mob", "Mod", "Mom", "Mop", "Mow", "Mud", "Mug", "Mum",
        "Nab", "Nag", "Nap", "Net", "New", "Nil", "Nip", "Nit", "Nod", "Nor", "Not", "Now", "Nut",
        "Oak", "Oar", "Oat", "Odd", "Off", "Oil", "Old", "One", "Opt", "Orb", "Ore", "Our", "Out", "Owl", "Own",
        "Pad", "Pal", "Pan", "Paw", "Pea", "Peg", "Pen", "Pet", "Pie", "Pig", "Pin", "Pit", "Pod", "Pop", "Pot", "Pry", "Pub", "Pug", "Pun", "Pup", "Pus", "Put",
        "Rag", "Ram", "Ran", "Rat", "Raw", "Ray", "Red", "Rib", "Rid", "Rig", "Rim", "Rob", "Rod", "Rot", "Row", "Rub", "Rug", "Run", "Rut",
        "Sad", "Sag", "Sap", "Sat", "Saw", "Say", "Sea", "Set", "She", "Shy", "Sin", "Sip", "Sir", "Sit", "Six", "Ski", "Sky", "Sly", "Sob", "Son", "Sop", "Sot", "Sow", "Soy", "Spa", "Spy", "Sub", "Sum", "Sun", "Sup",
        "Tab", "Tag", "Tan", "Tap", "Tar", "Tax", "Tea", "Ten", "The", "Tie", "Tin", "Tip", "Toe", "Ton", "Too", "Top", "Tow", "Toy", "Try", "Tub", "Tug", "Two",
        "Urn", "Use", "Van", "Vat", "Vet", "Vow",
        "Wag", "War", "Was", "Wax", "Way", "Web", "Wet", "Who", "Why", "Wig", "Win", "Wit", "Woe", "Wok", "Won", "Woo", "Wow",
        "Yak", "Yam", "Yap", "Yaw", "Yea", "Yes", "Yet", "Yew", "You",
        "Zap", "Zen", "Zig", "Zip", "Zoo",
        "Also", "Army", "Aunt", "Auto", "Away", "Axis",
        "Baby", "Back", "Ball", "Band", "Bank", "Base", "Bath", "Bear", "Beat", "Been", "Beer", "Bell", "Belt", "Best", "Bike", "Bill", "Bird", "Bite", "Blow", "Blue", "Boat", "Body", "Bomb", "Bond", "Bone", "Book", "Boom", "Boot", "Born", "Boss", "Both", "Bowl", "Buck", "Bull", "Burn", "Bush", "Busy",
        "Cage", "Cake", "Call", "Calm", "Came", "Camp", "Card", "Care", "Cart", "Case", "Cash", "Cast", "Cave", "Cell", "Cent", "Chat", "Chef", "Chew", "Chin", "Chip", "City", "Clam", "Clan", "Clap", "Claw", "Clay", "Clip", "Club", "Clue", "Coal", "Coat", "Code", "Coin", "Cold", "Comb", "Come", "Cook", "Cool", "Copy", "Cord", "Core", "Cork", "Corn", "Cost", "Cove", "Crab", "Crew", "Crop", "Crow", "Cube", "Cure", "Cute",
        "Dame", "Damp", "Dare", "Dark", "Dash", "Data", "Date", "Dawn", "Dead", "Deaf", "Deal", "Dear", "Debt", "Deck", "Deep", "Deer", "Demo", "Dent", "Deny", "Desk", "Dial", "Dice", "Diet", "Dirt", "Dish", "Disk", "Dock", "Dome", "Done", "Doom", "Door", "Dose", "Down", "Drag", "Draw", "Drip", "Drop", "Drug", "Drum", "Duck", "Duke", "Dull", "Dumb", "Dump", "Dune", "Dusk", "Dust", "Duty",
        "Each", "Earn", "Ease", "East", "Easy", "Edge", "Edit", "Else", "Emit", "Envy", "Epic", "Even", "Ever", "Evil", "Exam", "Exit",
        "Face", "Fact", "Fade", "Fail", "Fair", "Fake", "Fall", "Fame", "Farm", "Fast", "Fate", "Fear", "Feed", "Feel", "Feet", "Fell", "Felt", "File", "Fill", "Film", "Find", "Fine", "Fire", "Firm", "Fish", "Fist", "Five", "Flag", "Flat", "Flew", "Flex", "Flip", "Flow", "Foam", "Foil", "Fold", "Folk", "Fond", "Font", "Food", "Fool", "Foot", "Ford", "Fore", "Fork", "Form", "Fort", "Foul", "Four", "Free", "Frog", "From", "Fuel", "Full", "Fund", "Fury", "Fuse",
        "Gain", "Gale", "Game", "Gang", "Gash", "Gasp", "Gate", "Gave", "Gaze", "Gear", "Gene", "Gift", "Gill", "Girl", "Give", "Glad", "Glee", "Glow", "Glue", "Gnat", "Goal", "Goat", "Goes", "Gold", "Golf", "Gone", "Good", "Gore", "Gown", "Grab", "Gram", "Gray", "Grew", "Grid", "Grim", "Grin", "Grip", "Grit", "Grow", "Gulf", "Gull", "Gulp", "Gush", "Gust",
        "Hack", "Hail", "Hair", "Half", "Hall", "Halt", "Hand", "Hang", "Hard", "Hare", "Harm", "Harp", "Hash", "Hate", "Haul", "Have", "Haze", "Hazy", "Head", "Heal", "Heap", "Hear", "Heat", "Heel", "Help", "Herb", "Herd", "Here", "Hero", "Hide", "High", "Hike", "Hill", "Hilt", "Hint", "Hire", "Hiss", "Hive", "Hold", "Hole", "Home", "Hood", "Hook", "Hope", "Horn", "Hose", "Host", "Hour", "Howl", "Huge", "Hull", "Hung", "Hunt", "Hurl", "Hush", "Husk",
        "Ibis", "Icon", "Idea", "Idle", "Idol", "Inch", "Into", "Iron", "Isle", "Issue", "Item",
        "Jack", "Jade", "Jail", "Jazz", "Jeep", "Jerk", "Jest", "Jobs", "Join", "Joke", "Jolt", "Jury", "Just",
        "Keen", "Keep", "Kept", "Kick", "Kill", "Kind", "King", "Kiss", "Kite", "Knee", "Knew", "Knit", "Knob", "Knot", "Know",
        "Lace", "Lack", "Lady", "Lake", "Lamb", "Lame", "Lamp", "Land", "Lane", "Lark", "Lash", "Last", "Late", "Lawn", "Lazy", "Lead", "Leaf", "Leak", "Lean", "Leap", "Left", "Lend", "Lens", "Lent", "Less", "Liar", "Lick", "Life", "Lift", "Like", "Limb", "Lime", "Limp", "Line", "Link", "Lint", "Lion", "List", "Live", "Load", "Loaf", "Loan", "Lock", "Loft", "Lone", "Long", "Look", "Loom", "Loop", "Lord", "Lore", "Lose", "Loss", "Lost", "Lots", "Loud", "Love", "Luck", "Lump", "Lung", "Lure", "Lush", "Lust",
        "Made", "Maid", "Mail", "Main", "Make", "Male", "Mall", "Malt", "Mane", "Many", "Mare", "Mark", "Mars", "Mash", "Mask", "Mass", "Mast", "Mate", "Maze", "Mead", "Meal", "Mean", "Meat", "Meet", "Meld", "Melt", "Mend", "Menu", "Mere", "Mesa", "Mesh", "Mess", "Mild", "Mile", "Milk", "Mill", "Mind", "Mine", "Mint", "Miss", "Mist", "Moan", "Mold", "Mole", "Mood", "Moon", "Moor", "More", "Moss", "Most", "Moth", "Move", "Much", "Mule", "Mull", "Muse", "Mush", "Must", "Mute", "Myth",
        "Nail", "Name", "Nape", "Navy", "Near", "Neat", "Neck", "Need", "Nest", "Next", "Nice", "Nick", "Nine", "Node", "None", "Nook", "Noon", "Norm", "Nose", "Note", "Noun", "Nude", "Numb",
        "Oath", "Obey", "Oboe", "Odds", "Oils", "Oily", "Okay", "Omen", "Omit", "Once", "Only", "Onto", "Opal", "Open", "Oral", "Oust", "Oval", "Oven", "Over", "Owed", "Owl", "Owns",
        "Pace", "Pack", "Pact", "Page", "Paid", "Pain", "Pair", "Pale", "Palm", "Pane", "Park", "Part", "Pass", "Past", "Path", "Pave", "Pawn", "Peak", "Pear", "Peck", "Peel", "Peer", "Pelt", "Perm", "Pest", "Pick", "Pier", "Pike", "Pile", "Pill", "Pine", "Pink", "Pipe", "Plan", "Play", "Plea", "Plod", "Plot", "Plow", "Plug", "Plum", "Plus", "Poke", "Pole", "Poll", "Pond", "Pony", "Pool", "Poor", "Pope", "Pore", "Pork", "Port", "Pose", "Post", "Pour", "Pray", "Prep", "Prey", "Pump", "Punk", "Pure", "Push",
        "Quad", "Quit", "Quiz",
        "Race", "Rack", "Raft", "Rage", "Raid", "Rail", "Rain", "Rake", "Ramp", "Rang", "Rank", "Rant", "Rare", "Rash", "Rate", "Rave", "Read", "Real", "Reap", "Rear", "Reed", "Reef", "Reel", "Rein", "Rely", "Rend", "Rent", "Rest", "Rich", "Ride", "Rift", "Rill", "Rind", "Ring", "Riot", "Ripe", "Rise", "Risk", "Road", "Roam", "Roar", "Robe", "Rock", "Rode", "Role", "Roll", "Rome", "Roof", "Rook", "Room", "Root", "Rope", "Rose", "Rout", "Rove", "Rude", "Ruin", "Rule", "Rump", "Rung", "Ruse", "Rush", "Rust",
        "Sack", "Safe", "Sage", "Said", "Sail", "Sake", "Sale", "Salt", "Same", "Sand", "Sane", "Sang", "Sank", "Save", "Scan", "Scar", "Seal", "Seam", "Sear", "Seat", "Seed", "Seek", "Seem", "Seen", "Self", "Sell", "Send", "Sent", "Shed", "Shin", "Ship", "Shod", "Shoe", "Shop", "Shot", "Show", "Shut", "Sick", "Side", "Sift", "Sigh", "Sign", "Silk", "Sill", "Silt", "Sing", "Sink", "Sire", "Site", "Size", "Skid", "Skin", "Skip", "Slab", "Slam", "Slat", "Slay", "Sled", "Slew", "Slid", "Slim", "Slip", "Slit", "Slot", "Slow", "Slug", "Slum", "Snap", "Snip", "Snow", "Snug", "Soak", "Soar", "Sock", "Soda", "Sofa", "Soft", "Soil", "Sold", "Sole", "Solo", "Some", "Song", "Soon", "Sore", "Sort", "Soul", "Sour", "Span", "Spat", "Spin", "Spit", "Spot", "Spun", "Spur", "Stab", "Stag", "Star", "Stay", "Stem", "Step", "Stir", "Stop", "Stub", "Stud", "Stun", "Such", "Suck", "Suit", "Sulk", "Sung", "Sunk", "Sure", "Surf", "Swam", "Swan", "Swap", "Swim", "Sync",
        "Tack", "Tail", "Take", "Tale", "Talk", "Tall", "Tame", "Tank", "Tape", "Task", "Taxi", "Team", "Tear", "Tell", "Tend", "Tent", "Term", "Test", "Text", "Than", "That", "Them", "Then", "They", "Thin", "This", "Thus", "Tick", "Tide", "Tidy", "Tied", "Tier", "Tile", "Till", "Tilt", "Time", "Tiny", "Tire", "Toad", "Toil", "Told", "Tomb", "Tone", "Took", "Tool", "Tops", "Tore", "Torn", "Toss", "Tour", "Town", "Tram", "Trap", "Tray", "Tree", "Trim", "Trio", "Trip", "Trot", "True", "Tube", "Tuck", "Tuft", "Tuna", "Tune", "Turn", "Tusk", "Twin", "Type",
        "Ugly", "Unit", "Upon", "Urge", "Used", "User",
        "Vain", "Vale", "Vary", "Vase", "Vast", "Vein", "Vent", "Verb", "Very", "Vest", "Veto", "Vice", "View", "Vine", "Void", "Volt", "Vote",
        "Wade", "Wage", "Wait", "Wake", "Walk", "Wall", "Ward", "Warm", "Warn", "Warp", "Wary", "Wash", "Wasp", "Wave", "Weak", "Wean", "Wear", "Weed", "Week", "Weep", "Weld", "Well", "Went", "Were", "West", "What", "When", "Whim", "Whip", "Whom", "Wick", "Wide", "Wife", "Wild", "Will", "Wilt", "Wily", "Wind", "Wine", "Wing", "Wink", "Wipe", "Wire", "Wise", "Wish", "Wisp", "With", "Woke", "Wolf", "Womb", "Wood", "Wool", "Word", "Wore", "Work", "Worm", "Worn", "Wove", "Wrap",
        "Yank", "Yard", "Yarn", "Year", "Yell", "Yoga", "Yoke", "Your",
        "Zeal", "Zero", "Zinc", "Zone", "Zoom",
        "Axe", "Axes", "Box", "Boxes", "Fix", "Fox", "Foxes", "Hex", "Jinx", "Lynx", "Mix", "Next", "Nexus", "Ox", "Oxen", "Oxford", "Oxygen", "Proxy", "Relax", "Remix", "Sax", "Sex", "Six", "Sixty", "Tax", "Taxi", "Wax", "Xerox", "Xylem", "Xylophone",
        "Cats", "Dogs", "Birds", "Fish", "Trees", "Books", "Cars", "Houses", "Hands", "Eyes",
        "Nylon", "Nylons", "Nymph", "Nymphs",
        "Promise", "Promises", "Promised", "Promising",
        "Running", "Walking", "Talking", "Eating", "Drinking", "Sleeping",
        "Played", "Worked", "Wanted", "Needed", "Started", "Ended",
        "Xenon", "Xenophobia", "Xerox", "Xerography", "Xylem", "Xylene", "Xylophone", "Xylophonist",
        "Axe", "Axes", "Axed", "Axing", "Axial", "Axilla", "Axiom", "Axis", "Axle", "Axles", "Axon", "Axons",
        "Box", "Boxed", "Boxer", "Boxers", "Boxes", "Boxing", "Boxcar", "Boxfish", "Boxwood",
        "Fix", "Fixed", "Fixer", "Fixes", "Fixing", "Fixture", "Fixity", "Fixture",
        "Fox", "Foxed", "Foxes", "Foxhole", "Foxhound", "Foxing", "Foxtrot", "Foxy",
        "Hex", "Hexed", "Hexes", "Hexagon", "Hexagram", "Hexahedron", "Hexameter", "Hexane",
        "Jinx", "Jinxed", "Jinxes", "Jinxing",
        "Lax", "Laxity", "Laxly", "Laxness",
        "Lynx", "Lynxes",
        "Max", "Maxed", "Maxes", "Maxi", "Maxim", "Maxima", "Maximal", "Maximum", "Maximus", "Maxing",
        "Mix", "Mixed", "Mixer", "Mixers", "Mixes", "Mixing", "Mixture", "Mixtures", "Mixup",
        "Next", "Nexus", "Nexuses",
        "Ox", "Oxalate", "Oxblood", "Oxbow", "Oxcart", "Oxen", "Oxford", "Oxide", "Oxides", "Oxidize", "Oximeter", "Oxlip", "Oxpecker", "Oxtail", "Oxygen", "Oxygenate", "Oyster",
        "Pax", "Pixel", "Pixels", "Pixie", "Pixies", "Pox", "Poxes", "Proxy", "Proxies", "Proximo",
        "Relax", "Relaxed", "Relaxes", "Relaxing", "Relaxation", "Remix", "Remixed", "Remixes", "Remixing",
        "Sax", "Saxes", "Saxon", "Saxophone", "Saxophonist", "Sex", "Sexed", "Sexes", "Sexier", "Sexiest", "Sexily", "Sexing", "Sexism", "Sexist", "Sexless", "Sextant", "Sextet", "Sexton", "Sexual", "Sexy",
        "Six", "Sixes", "Sixfold", "Sixpence", "Sixpenny", "Sixteen", "Sixth", "Sixtieth", "Sixty", "Sixer",
        "Tax", "Taxable", "Taxation", "Taxed", "Taxes", "Taxi", "Taxicab", "Taxidermy", "Taxied", "Taxiing", "Taxing", "Taxiway", "Taxman", "Taxon", "Taxonomy", "Taxpayer",
        "Text", "Textbook", "Textile", "Textiles", "Texting", "Texts", "Textual", "Texture", "Textured", "Textures",
        "Vex", "Vexed", "Vexes", "Vexing", "Vexation", "Vexatious",
        "Wax", "Waxed", "Waxen", "Waxes", "Waxing", "Waxwork", "Waxy",
        "Xray", "Xrays", "Xenon", "Xeric", "Xeroxed", "Xeroxes", "Xeroxing", "Xmas", "Xrayed", "Xraying",
        "Zax", "Zaxes", "Zaxxon"
    }
}

local palavrasES = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Y", "Al", "Am", "An", "Ar", "As", "Ay",
        "Be", "Bi", "Bo", "Bu", "Ca", "Ce", "Ci", "Co", "Cu", "Da", "De", "Di", "Do", "Du",
        "El", "En", "Es", "Ex", "Fa", "Fe", "Fi", "Fo", "Fu",
        "Ga", "Ge", "Gi", "Go", "Gu", "Ha", "He", "Hi", "Ho", "Hu",
        "Ia", "Io", "Ir", "Is", "It", "La", "Le", "Li", "Lo", "Lu",
        "Ma", "Me", "Mi", "Mo", "Mu", "Na", "Ne", "Ni", "No", "Nu",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Si", "So", "Su", "Ta", "Te", "Ti", "To", "Tu",
        "Un", "Una", "Unas", "Unos", "Va", "Ve", "Vi", "Vo", "Vu",
        "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu"
    },
    ["COMPLETAS"] = {
        "Aceite", "Agua", "Aire", "Alegre", "Alma", "Amigo", "Amor", "Animal", "Arbol",
        "Bebe", "Bello", "Beso", "Blanco", "Boca", "Bola", "Brazo", "Brisa", "Bueno", "Buscar",
        "Calor", "Cama", "Carta", "Casa", "Chapa", "Charco", "Chica", "Chico", "Chino", "Chiste", "Chocolate", "Chuleta", "Ciego", "Cielo", "Cine", "Copa", "Cuerpo",
        "Dado", "Danza", "Dedo", "Dia", "Diente", "Dios", "Dolor", "Don", "Dulce", "Duna",
        "Eco", "Edad", "Eje", "Elefante", "Enano", "Entrar", "Era", "Escuela", "Estrella", "Etico",
        "Fama", "Fase", "Fe", "Fiesta", "Fin", "Flor", "Foca", "Frio", "Fuego", "Fuga",
        "Gato", "Gente", "Gol", "Gota", "Grama", "Grande", "Grato", "Grito", "Gula",
        "Habilidad", "Harpa", "Hielo", "Hiena", "Hijo", "Himno", "Hoja", "Hora", "Hotel", "Humor",
        "Idolo", "Iglesia", "Iman", "India", "Insecto", "Invierno", "Ir", "Isla",
        "Jabon", "Jamon", "Jefe", "Jesus", "Jirafa", "Joven", "Joya", "Juego", "Junto",
        "Kilo", "Karma", "Karate", "Kayak", "Kebab", "Ketchup", "Kiwi", "Koala",
        "Largo", "Lata", "Leche", "Leon", "Libro", "Lince", "Lindo", "Loco", "Luna", "Luz",
        "Madre", "Malo", "Mano", "Mar", "Mesa", "Miel", "Moto", "Mucho", "Muerto", "Mundo",
        "Nada", "Nave", "Nido", "Nieto", "Noble", "Noche", "Norte", "Nube", "Nueve", "Nuez",
        "Obra", "Ocho", "Oeste", "Ojo", "Ola", "Orden", "Oreja", "Oro", "Oso",
        "Pan", "Pato", "Paz", "Pena", "Pez", "Piedra", "Piel", "Piso", "Plato", "Puerta",
        "Queso", "Quimica", "Quince", "Quitar", "Querer", "Quieto",
        "Rama", "Rapido", "Raton", "Red", "Rey", "Rico", "Rio", "Ropa", "Rosa", "Rueda",
        "Sal", "Santo", "Sapo", "Sed", "Seda", "Selva", "Si", "Silla", "Sol", "Suerte",
        "Taza", "Techo", "Tela", "Tiempo", "Tierra", "Tigre", "Todo", "Toro", "Tren", "Trono",
        "Una", "Unico", "Union", "Uno", "Urgente", "Uso", "Uva",
        "Vaca", "Valle", "Vaso", "Vela", "Verde", "Vida", "Vidrio", "Viejo", "Viento", "Voz",
        "Exacto", "Examen", "Exito", "Exotico", "Extra", "Flexible", "Texto", "Toxico",
        "Yoga", "Yogurt", "Yate", "Yen", "Yin",
        "Zona", "Zoo", "Zapato", "Zanahoria",
        "Exito", "Examen", "Exacto", "Exagerar", "Exaltar", "Examinar", "Exasperar", "Excavar", "Exceder", "Excelente", "Excentrico", "Excepcion", "Exceso", "Excitar", "Exclamar", "Excluir", "Excremento", "Exculpar", "Excursion", "Excusa",
        "Execrar", "Exegesis", "Exento", "Exequias", "Exfoliar", "Exhalar", "Exhausto", "Exhibir", "Exhortar", "Exhumar", "Exigir", "Exiguo", "Exilio", "Eximir", "Existir", "Exito", "Exodo", "Exonerar", "Exorbitante", "Exorcismo", "Exordio",
        "Expandir", "Expansion", "Expatriar", "Expectar", "Expedir", "Expeler", "Experto", "Expiar", "Expirar", "Explicar", "Explorar", "Explosion", "Exponer", "Exportar", "Exposito", "Expresar", "Exprimir", "Expuesto", "Expulsar", "Expurgar",
        "Extasis", "Extender", "Extension", "Extenuar", "Exterior", "Exterminar", "Externo", "Extinguir", "Extirpar", "Extorsion", "Extra", "Extraer", "Extranjero", "Extrano", "Extraviar", "Extremo", "Extrinseco", "Exuberante", "Exultar", "Exvoto",
        "Saxofon", "Saxofonista", "Sexo", "Sexual", "Sexto", "Sextante", "Sexteto", "Sextuplicar",
        "Boxeo", "Boxeador", "Boxear", "Flexion", "Flexible", "Flexibilidad", "Flexo", "Hexagono", "Hexaedro",
        "Maximo", "Maximal", "Maximizar", "Mixto", "Mixtura", "Oxido", "Oxigeno", "Oxidar", "Paradoja", "Paradoxo",
        "Proximo", "Proximidad", "Reflexion", "Reflexivo", "Reflexar", "Sintaxis", "Taxi", "Taxista", "Taxonomia",
        "Texto", "Textil", "Textura", "Toxico", "Toxina", "Toxicidad", "Torax", "Xenofobia", "Xenofobo",
        "Xerografia", "Xerografiar", "Xilofono", "Xilografia", "Xilografo"
    }
}

local palavrasTerminamY = {
    A = {"angry", "away", "airy", "army", "ability", "activity", "anniversary", "allergy", "agency", "anatomy", "anxiety", "actually", "accuracy", "academy", "agility", "apology", "assembly", "antony", "anthony"},
    B = {"baby", "body", "busy", "berry", "bloody", "buddy", "bakery", "bravery", "biology", "balcony", "beauty", "bouncy", "brainy", "bushy", "bubbly", "buttery", "boundary", "bunny"},
    C = {"city", "copy", "candy", "cloudy", "crazy", "comfy", "colony", "comedy", "century", "charity", "currency", "creamy", "chilly", "cheeky", "crispy", "cuddly", "cavity"},
    D = {"day", "dirty", "diary", "daddy", "daily", "dusty", "delivery", "deputy", "discovery", "destiny", "dignity", "dreamy", "dizzy", "drizzly", "daffy", "dandy", "dummmy"},
    E = {"easy", "early", "empty", "entry", "enemy", "energy", "eternity", "embassy", "entity", "economy", "efficiency", "essay", "envy", "everybody", "especially", "emergency"},
    F = {"funny", "fairy", "friendly", "family", "fancy", "foggy", "filthy", "frequency", "fantasy", "fidelity", "fury", "fluffy", "fishy", "frosty", "funky", "fully", "factory"},
    G = {"gray", "guilty", "glory", "gummy", "giddy", "galaxy", "generosity", "grassy", "gay", "grocery", "gravity", "glitchy", "gooey", "gravy", "greedy", "groovy"},
    H = {"happy", "hungry", "hairy", "hobby", "heavy", "healthy", "honey", "hurry", "history", "harmony", "highway", "holy", "handy", "hasty", "hearty"},
    I = {"icy", "ivory", "inky", "identity", "injury", "irony", "inquiry", "industry", "infinity", "imagery", "itchy", "inventory", "immunity"},
    J = {"jelly", "juicy", "jolly", "jerky", "jeopardy", "journey", "jellybean", "jaunty", "judiciary", "jewelry", "jumpy", "jokey", "jingly", "joy"},
    K = {"kitty", "kindly", "knobby", "kidney", "key", "knavery", "knotty", "kittycat", "knowingly", "kooky", "kingly", "klutzy"},
    L = {"lazy", "lucky", "lovely", "lorry", "lively", "lonely", "liberty", "laundry", "luxury", "legacy", "locality", "leafy", "lengthy", "lousy", "loopy", "lumpy", "larry"},
    M = {"money", "messy", "mighty", "mommy", "memory", "melody", "mystery", "mercy", "monkey", "ministry", "murky", "moldy", "moody", "mushy", "minty", "mastery"},
    N = {"noisy", "navy", "naughty", "ninety", "nervy", "nobody", "necessity", "nursery", "nationality", "novelty", "natty", "nifty", "needy", "nutty"},
    O = {"only", "oily", "orderly", "occupancy", "ordinary", "obituary", "opportunity", "obesity", "originality", "okay", "oddly", "overly", "openly", "orangey"},
    P = {"party", "puppy", "pretty", "plenty", "penny", "pantry", "philosophy", "poetry", "priority", "property", "perry", "parry", "puny", "poky", "puffy", "prickly"},
    Q = {"quarry", "query", "queasy", "quality", "quantity", "quirky", "queenly", "quarterly", "quietly", "quivery", "quaky"},
    R = {"rainy", "rosy", "rusty", "roomy", "remedy", "royalty", "reality", "rivalry", "recovery", "railway", "runny", "ray", "ready", "rocky", "rowdy", "rubbery"},
    S = {"sunny", "sorry", "shiny", "silly", "sleepy", "stormy", "safety", "strategy", "sexy", "salary", "society", "slowly", "sandy", "smoky", "snowy", "sticky"},
    T = {"tiny", "tasty", "twenty", "thirsty", "theory", "trophy", "tragedy", "tidy", "technology", "territory", "try", "testy", "touchy", "tricky", "twitchy", "temporally"},
    U = {"ugly", "unity", "unwary", "unlucky", "uneasy", "unworthy", "utility", "university", "urgency", "uppity", "usually"},
    V = {"very", "victory", "valley", "velocity", "vacancy", "vanity", "viceroy", "variety", "viability", "vinegary", "velvety"},
    W = {"worry", "windy", "wealthy", "worthy", "weekly", "watery", "wavy", "wildly", "warranty", "worldly", "woody", "woolly", "wintry", "wiry"},
    Y = {"yummy", "yearly", "yeasty", "yellowy", "yucky", "youthfully", "yesterday"},
    Z = {"zany", "zingy", "zooey", "zesty", "zoomy", "zizzy", "zealotry", "zippy", "zoophyly"}
}

local coreGui = game:GetService("CoreGui") or game:GetService("StarterGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VortexAutoType"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.Parent = coreGui

local PADDING = 16
local scriptAtivo = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 400)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(45, 45, 70)
stroke.Thickness = 1.5

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, PADDING, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Vortex - Finish The Word"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 11
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -72, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.ZIndex = 11
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.ZIndex = 11
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -PADDING*2, 1, -42 - PADDING*2)
contentContainer.Position = UDim2.new(0, PADDING, 0, 42 + PADDING)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 10
contentContainer.Parent = mainFrame

local isMinimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 620, 0, 42)
        minimizeBtn.Text = "+"
        contentContainer.Visible = false
    else
        mainFrame.Size = originalSize
        minimizeBtn.Text = "−"
        contentContainer.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    scriptAtivo = false
    screenGui:Destroy()
end)

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.49, 0, 1, 0)
leftFrame.Position = UDim2.new(0, 0, 0, 0)
leftFrame.BackgroundTransparency = 1
leftFrame.ZIndex = 10
leftFrame.Parent = contentContainer

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 50)
statusFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
statusFrame.ZIndex = 10
statusFrame.Parent = leftFrame
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", statusFrame).Color = Color3.fromRGB(0, 170, 100)

local powerToggle = Instance.new("TextButton")
powerToggle.Size = UDim2.new(0, 44, 0, 24)
powerToggle.Position = UDim2.new(1, -PADDING - 44, 0.5, -12)
powerToggle.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
powerToggle.Text = "ON"
powerToggle.TextColor3 = Color3.fromRGB(20, 20, 20)
powerToggle.Font = Enum.Font.GothamBold
powerToggle.TextSize = 11
powerToggle.ZIndex = 11
powerToggle.Parent = statusFrame
Instance.new("UICorner", powerToggle).CornerRadius = UDim.new(0, 12)

local botAtivo = true

powerToggle.MouseButton1Click:Connect(function()
    botAtivo = not botAtivo
    if botAtivo then
        powerToggle.Text = "ON"
        powerToggle.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        powerToggle.TextColor3 = Color3.fromRGB(20, 20, 20)
    else
        powerToggle.Text = "OFF"
        powerToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        powerToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local greenDot = Instance.new("Frame")
greenDot.Size = UDim2.new(0, 10, 0, 10)
greenDot.Position = UDim2.new(0, PADDING, 0.5, -5)
greenDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
greenDot.ZIndex = 10
greenDot.Parent = statusFrame
Instance.new("UICorner", greenDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -120, 1, 0)
statusLabel.Position = UDim2.new(0, 34, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Waiting for your turn..."
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.ZIndex = 10
statusLabel.Parent = statusFrame

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 1, -62)
toggleFrame.Position = UDim2.new(0, 0, 0, 62)
toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
toggleFrame.ZIndex = 10
toggleFrame.Parent = leftFrame
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 10)

local hardModeTitle = Instance.new("TextLabel")
hardModeTitle.Size = UDim2.new(1, -PADDING*2, 0, 22)
hardModeTitle.Position = UDim2.new(0, PADDING, 0, PADDING)
hardModeTitle.BackgroundTransparency = 1
hardModeTitle.Text = "🔴 Hard Mode"
hardModeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
hardModeTitle.Font = Enum.Font.GothamBold
hardModeTitle.TextSize = 13
hardModeTitle.TextXAlignment = Enum.TextXAlignment.Left
hardModeTitle.ZIndex = 10
hardModeTitle.Parent = toggleFrame

local hardModeDesc = Instance.new("TextLabel")
hardModeDesc.Size = UDim2.new(1, -PADDING*2, 0, 24)
hardModeDesc.Position = UDim2.new(0, PADDING, 0, PADDING + 22)
hardModeDesc.BackgroundTransparency = 1
hardModeDesc.Text = "Only uses words ending with 'Y' to make it harder for opponents"
hardModeDesc.TextColor3 = Color3.fromRGB(140, 140, 170)
hardModeDesc.Font = Enum.Font.Gotham
hardModeDesc.TextSize = 9
hardModeDesc.TextWrapped = true
hardModeDesc.TextXAlignment = Enum.TextXAlignment.Left
hardModeDesc.ZIndex = 10
hardModeDesc.Parent = toggleFrame

local hardToggleBtn = Instance.new("TextButton")
hardToggleBtn.Size = UDim2.new(1, -PADDING*2, 0, 36)
hardToggleBtn.Position = UDim2.new(0, PADDING, 0, PADDING + 50)
hardToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
hardToggleBtn.Text = "DISABLED"
hardToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
hardToggleBtn.Font = Enum.Font.GothamBold
hardToggleBtn.TextSize = 14
hardToggleBtn.ZIndex = 11
hardToggleBtn.Parent = toggleFrame
Instance.new("UICorner", hardToggleBtn).CornerRadius = UDim.new(0, 8)

local hardMode = false

hardToggleBtn.MouseButton1Click:Connect(function()
    hardMode = not hardMode
    if hardMode then
        hardToggleBtn.Text = "ENABLED"
        hardToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        hardToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        hardModeTitle.Text = "🟢 Hard Mode"
    else
        hardToggleBtn.Text = "DISABLED"
        hardToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        hardToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        hardModeTitle.Text = "🔴 Hard Mode"
    end
end)

local safeModeTitle = Instance.new("TextLabel")
safeModeTitle.Size = UDim2.new(1, -PADDING*2, 0, 22)
safeModeTitle.Position = UDim2.new(0, PADDING, 0, PADDING + 105)
safeModeTitle.BackgroundTransparency = 1
safeModeTitle.Text = "🔴 Safe Mode"
safeModeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
safeModeTitle.Font = Enum.Font.GothamBold
safeModeTitle.TextSize = 13
safeModeTitle.TextXAlignment = Enum.TextXAlignment.Left
safeModeTitle.ZIndex = 10
safeModeTitle.Parent = toggleFrame

local safeModeDesc = Instance.new("TextLabel")
safeModeDesc.Size = UDim2.new(1, -PADDING*2, 0, 24)
safeModeDesc.Position = UDim2.new(0, PADDING, 0, PADDING + 127)
safeModeDesc.BackgroundTransparency = 1
safeModeDesc.Text = "Stops after 4 attempts, waits for you to type the 5th"
safeModeDesc.TextColor3 = Color3.fromRGB(140, 140, 170)
safeModeDesc.Font = Enum.Font.Gotham
safeModeDesc.TextSize = 9
safeModeDesc.TextWrapped = true
safeModeDesc.TextXAlignment = Enum.TextXAlignment.Left
safeModeDesc.ZIndex = 10
safeModeDesc.Parent = toggleFrame

local safeToggleBtn = Instance.new("TextButton")
safeToggleBtn.Size = UDim2.new(1, -PADDING*2, 0, 36)
safeToggleBtn.Position = UDim2.new(0, PADDING, 0, PADDING + 155)
safeToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
safeToggleBtn.Text = "DISABLED"
safeToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
safeToggleBtn.Font = Enum.Font.GothamBold
safeToggleBtn.TextSize = 14
safeToggleBtn.ZIndex = 11
safeToggleBtn.Parent = toggleFrame
Instance.new("UICorner", safeToggleBtn).CornerRadius = UDim.new(0, 8)

local safeMode = false

safeToggleBtn.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    if safeMode then
        safeToggleBtn.Text = "ENABLED"
        safeToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        safeToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        safeModeTitle.Text = "🟢 Safe Mode"
    else
        safeToggleBtn.Text = "DISABLED"
        safeToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        safeToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        safeModeTitle.Text = "🔴 Safe Mode"
    end
end)

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.49, 0, 1, 0)
rightFrame.Position = UDim2.new(0.51, 0, 0, 0)
rightFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
rightFrame.ZIndex = 10
rightFrame.Parent = contentContainer
Instance.new("UICorner", rightFrame).CornerRadius = UDim.new(0, 10)

local detalhesLabel = Instance.new("TextLabel")
detalhesLabel.Size = UDim2.new(1, 0, 0, 24)
detalhesLabel.Position = UDim2.new(0, 0, 0, PADDING)
detalhesLabel.BackgroundTransparency = 1
detalhesLabel.Text = "Session Details"
detalhesLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
detalhesLabel.Font = Enum.Font.GothamBold
detalhesLabel.TextSize = 15
detalhesLabel.TextXAlignment = Enum.TextXAlignment.Center
detalhesLabel.ZIndex = 10
detalhesLabel.Parent = rightFrame

local ROW_HEIGHT = 36
local ROW_PADDING = 12
local ROW_GAP = 44

local function createInfoRow(parent, yPos, labelText, valueText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -PADDING*2, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, PADDING, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    row.ZIndex = 10
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.42, 0, 1, 0)
    label.Position = UDim2.new(0, ROW_PADDING, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(160, 160, 190)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 10
    label.Parent = row
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.58, -ROW_PADDING*2, 1, 0)
    value.Position = UDim2.new(0.42, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Text = valueText
    value.TextColor3 = Color3.fromRGB(255, 255, 255)
    value.Font = Enum.Font.GothamBold
    value.TextSize = 13
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 10
    value.Parent = row
    
    return value
end

local rightStartY = PADDING + 30
local detIdioma   = createInfoRow(rightFrame, rightStartY + ROW_GAP*0, "Language", "EN")
local detPalavras = createInfoRow(rightFrame, rightStartY + ROW_GAP*1, "Words",    "0")
local detMesa     = createInfoRow(rightFrame, rightStartY + ROW_GAP*2, "Table",    "-")
local detPalavra  = createInfoRow(rightFrame, rightStartY + ROW_GAP*3, "Word",     "0")

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function detectarIdioma()
    local locale = nil
    pcall(function() locale = player.LocaleId end)
    if locale then
        locale = locale:lower()
        if locale:find("pt") then return "PT-BR", palavrasPT end
        if locale:find("es") then return "ES", palavrasES end
    end
    return "EN", palavrasEN
end

local idioma, palavrasCategoria = detectarIdioma()

local function encontrarPalavras(prefixo, tentadas)
    local candidatas = {}
    
    if hardMode then
        local primeiraLetra = prefixo:sub(1, 1)
        if palavrasTerminamY[primeiraLetra] then
            for _, p in pairs(palavrasTerminamY[primeiraLetra]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
    end
    
    if #candidatas == 0 then
        if palavrasCategoria["COMPLETAS"] then
            for _, p in pairs(palavrasCategoria["COMPLETAS"]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
        if palavrasCategoria["CURTAS"] then
            for _, p in pairs(palavrasCategoria["CURTAS"]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and pu ~= prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
    end
    
    return candidatas
end

local function getPlayerAttributes()
    local inGame, isTurn = nil, nil
    pcall(function() inGame = player:GetAttribute("InGame") end)
    pcall(function() isTurn = player:GetAttribute("IsTurn") end)
    return inGame, isTurn
end

local function findMyTable(mesaNumero)
    if not mesaNumero then return nil, nil end
    local metaFolder = workspace:FindFirstChild("Meta")
    if not metaFolder then return nil, nil end
    local tables = metaFolder:FindFirstChild("Tables")
    if not tables then return nil, nil end
    for _, model in pairs(tables:GetChildren()) do
        if model:IsA("Model") and model.Name == tostring(mesaNumero) then
            local tableModel = model:FindFirstChild("Table")
            if tableModel then
                local matchDisplay = tableModel:FindFirstChild("MatchDisplay")
                if matchDisplay then return matchDisplay, model.Name end
            end
        end
    end
    return nil, nil
end

local function getPrefixo(matchDisplay)
    if not matchDisplay then return nil end
    local category = matchDisplay:FindFirstChild("Category")
    if category and category:IsA("TextLabel") then
        local texto = category.Text:upper():gsub("%s+", "")
        if texto ~= "" and #texto <= 10 then return texto end
    end
    return nil
end

local function getPalavraDoPet(matchDisplay, temHydra)
    if not temHydra or not matchDisplay then return "", 0 end
    local answerInput = matchDisplay:FindFirstChild("AnswerInput")
    if not answerInput then
        for _, child in pairs(matchDisplay:GetDescendants()) do
            if child.Name == "AnswerInput" then answerInput = child; break end
        end
    end
    if not answerInput then return "", 0 end
    local keys = answerInput:FindFirstChild("Keys")
    if not keys then return "", 0 end
    local count = 0; local letras = ""
    for _, key in pairs(keys:GetChildren()) do
        if key:IsA("TextButton") or key:IsA("ImageButton") or key:IsA("GuiButton") or key:IsA("Frame") then
            count = count + 1
            local keyText = key:FindFirstChildWhichIsA("TextLabel")
            if keyText and keyText.Text ~= "" then letras = letras .. keyText.Text end
        end
    end
    if count > 1 and letras ~= "" then return letras:upper(), count end
    return "", 0
end

local function temPetHydraNaMesa(mesaNumero)
    if not mesaNumero then return false end
    local metaFolder = workspace:FindFirstChild("Meta")
    if not metaFolder then return false end
    local tables = metaFolder:FindFirstChild("Tables")
    if not tables then return false end
    for _, model in pairs(tables:GetChildren()) do
        if model:IsA("Model") and model.Name == tostring(mesaNumero) then
            local matchPets = model:FindFirstChild("MatchPets")
            if matchPets then
                for _, playerFolder in pairs(matchPets:GetChildren()) do
                    if playerFolder:IsA("Folder") or playerFolder:IsA("Model") then
                        local pet = playerFolder:FindFirstChild("Pet")
                        if pet and pet:IsA("Model") and pet:GetAttribute("Hydra") then return true end
                    end
                end
            end
            break
        end
    end
    return false
end

local function apagarLetras(qtd)
    if qtd <= 0 then return end
    for i = 1, qtd do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, nil)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, nil)
        task.wait(0.06)
    end
    task.wait(0.2)
end

local function digitarResto(palavra, base)
    local resto = palavra:sub(#base + 1)
    if resto == "" then
        task.wait(0.2)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
        return 0
    end
    for letra in resto:gmatch(".") do
        local keyCode = Enum.KeyCode[letra:upper()]
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
            task.wait(0.09)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
            task.wait(0.07)
        end
    end
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
    task.wait(0.08)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
    return #resto
end

local verificando = false
local tempoEnvio = 0
local tentativas = 0
local MAX_TENTATIVAS = 5
local TEMPO_VERIFICACAO = 0.8
local TEMPO_TOTAL = 14
local inicioRodada = 0
local baseAtual = ""
local ultimaBase = ""
local qtdLetrasDigitadas = 0
local ultimaPalavra = nil
local temHydra = false
local palavrasTentadas = {}

local function atualizarInterface(statusMsg, idiomaStr, palavrasCount, mesaStr, baseStr)
    if not botAtivo then
        statusLabel.Text = "PAUSED - Click ON to resume"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        greenDot.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    statusLabel.Text = statusMsg
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    greenDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    detIdioma.Text = idiomaStr
    detPalavras.Text = tostring(palavrasCount)
    detMesa.Text = mesaStr
    detPalavra.Text = baseStr
end

while scriptAtivo do
    local inGame, isTurn = getPlayerAttributes()
    
    if not botAtivo then
        atualizarInterface("PAUSED - Click ON to resume", idioma, 0, "-", "0")
        verificando = false
        tentativas = 0
        palavrasTentadas = {}
        ultimaBase = ""
        task.wait(0.3)
        continue
    end
    
    if inGame then
        local matchDisplay, mesaNumero = findMyTable(inGame)
        
        if matchDisplay then
            temHydra = temPetHydraNaMesa(inGame)
            local prefixo = getPrefixo(matchDisplay)
            local palavraPet = getPalavraDoPet(matchDisplay, temHydra)
            
            local baseAgora = ""
            
            if palavraPet ~= "" then
                baseAgora = palavraPet
                MAX_TENTATIVAS = safeMode and 4 or 15
                TEMPO_VERIFICACAO = 1.0
            elseif prefixo then
                baseAgora = prefixo
                MAX_TENTATIVAS = safeMode and 4 or 5
                TEMPO_VERIFICACAO = 0.8
            end
            
            local palavrasCount = 0
            if baseAgora ~= "" then
                local candidatasTemp = encontrarPalavras(baseAgora, {})
                palavrasCount = #candidatasTemp
            end
            
            if baseAgora ~= "" then
                if baseAgora ~= ultimaBase then
                    ultimaBase = baseAgora
                    tentativas = 0
                    palavrasTentadas = {}
                    verificando = false
                    inicioRodada = os.clock()
                end
                
                local tempoRestante = TEMPO_TOTAL - (os.clock() - inicioRodada)
                if tempoRestante < 0 then tempoRestante = 0 end
                
                if isTurn or verificando then
                    
                    if verificando then
                        local tempoPassado = os.clock() - tempoEnvio
                        
                        if tempoPassado > TEMPO_VERIFICACAO then
                            local _, aindaTurno = getPlayerAttributes()
                            
                            if aindaTurno then
                                apagarLetras(qtdLetrasDigitadas)
                                if ultimaPalavra then 
                                    palavrasTentadas[ultimaPalavra:upper()] = true 
                                end
                                tentativas = tentativas + 1
                                
                                if tentativas > MAX_TENTATIVAS or tempoRestante <= 0 then
                                    local msg
                                    if safeMode and tentativas > MAX_TENTATIVAS then
                                        msg = "SAFE MODE: Waiting for you..."
                                    elseif tentativas > MAX_TENTATIVAS then
                                        msg = "Max attempts (" .. MAX_TENTATIVAS .. ")"
                                    else
                                        msg = "Time out!"
                                    end
                                    atualizarInterface(msg, idioma, palavrasCount, mesaNumero or "-", baseAgora)
                                    verificando = false
                                else
                                    local candidatas = encontrarPalavras(baseAgora, palavrasTentadas)
                                    
                                    if #candidatas > 0 then
                                        local palavra = candidatas[math.random(1, #candidatas)]
                                        palavrasTentadas[palavra:upper()] = true
                                        
                                        atualizarInterface("Your turn! (" .. string.format("%.1f", tempoRestante) .. "s)", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                                        
                                        qtdLetrasDigitadas = digitarResto(palavra, baseAgora)
                                        ultimaPalavra = palavra
                                        tempoEnvio = os.clock()
                                    else
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                                        task.wait(0.08)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                                        tentativas = tentativas + 1
                                        tempoEnvio = os.clock()
                                    end
                                end
                            else
                                atualizarInterface("Accepted!", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                                verificando = false
                                tentativas = 0
                                palavrasTentadas = {}
                            end
                        else
                            atualizarInterface("Verifying... (" .. string.format("%.1f", tempoRestante) .. "s)", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                        end
                    else
                        tentativas = 1
                        inicioRodada = os.clock()
                        
                        local candidatas = encontrarPalavras(baseAgora, palavrasTentadas)
                        
                        if #candidatas > 0 then
                            local palavra = candidatas[math.random(1, #candidatas)]
                            palavrasTentadas[palavra:upper()] = true
                            
                            atualizarInterface("Your turn! (" .. string.format("%.1f", TEMPO_TOTAL) .. "s)", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                            
                            task.wait(0.5 + math.random() * 0.5)
                            qtdLetrasDigitadas = digitarResto(palavra, baseAgora)
                            ultimaPalavra = palavra
                            tempoEnvio = os.clock()
                            verificando = true
                        else
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
                            task.wait(0.08)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
                            tempoEnvio = os.clock()
                            verificando = true
                            qtdLetrasDigitadas = 0
                            ultimaPalavra = baseAgora
                        end
                    end
                else
                    atualizarInterface("Waiting for your turn...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                    verificando = false
                    tentativas = 0
                    palavrasTentadas = {}
                end
            else
                atualizarInterface("Waiting for letters...", idioma, 0, mesaNumero or "-", "0")
                verificando = false
            end
        else
            atualizarInterface("Searching table " .. inGame .. "...", idioma, 0, "-", "0")
            verificando = false
        end
    else
        atualizarInterface("Not in game", idioma, 0, "-", "0")
        verificando = false
        tentativas = 0
        palavrasTentadas = {}
        ultimaBase = ""
    end
    
    task.wait(0.15)
end