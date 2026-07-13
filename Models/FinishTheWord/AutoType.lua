-- Verifica se já existe uma instância do painel
local function checkExistingPanel()
    local coreGui = game:GetService("CoreGui") or game:GetService("StarterGui")
    for _, child in pairs(coreGui:GetChildren()) do
        if child.Name == "VortexAutoType" then
            return true
        end
    end
    return false
end

if checkExistingPanel() then
    return
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

-- Função para auto-escolha de letras no ChoiceList - CORRIGIDA
local function autoEscolherLetra()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then 
        return false 
    end
    
    -- Procura ScreenGui em todos os ScreenGuis do jogador
    local screenGui = nil
    for _, child in pairs(playerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child:FindFirstChild("ChoiceList") then
            screenGui = child
            break
        end
    end
    
    if not screenGui then 
        return false 
    end
    
    local choiceList = screenGui:FindFirstChild("ChoiceList")
    if not choiceList then 
        return false 
    end
    
    -- Verifica se está visível (é nossa vez de escolher)
    if not choiceList.Visible then 
        return false 
    end
    
    -- Procura por ImageButtons/ImageLabels/TextButtons dentro do ChoiceList
    local opcoes = {}
    
    -- Procura diretamente nos filhos
    for _, child in pairs(choiceList:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("ImageLabel") or child:IsA("TextButton") then
            if child.Visible then
                table.insert(opcoes, child)
            end
        end
    end
    
    -- Se não encontrou, procura em sub-frames
    if #opcoes == 0 then
        for _, child in pairs(choiceList:GetDescendants()) do
            if child:IsA("ImageButton") or child:IsA("ImageLabel") or child:IsA("TextButton") then
                if child.Visible then
                    table.insert(opcoes, child)
                end
            end
        end
    end
    
    if #opcoes == 0 then 
        return false 
    end
    
    -- Remove duplicatas
    local unicas = {}
    local seen = {}
    for _, op in ipairs(opcoes) do
        if not seen[op] then
            seen[op] = true
            table.insert(unicas, op)
        end
    end
    
    if #unicas < 2 then 
        return false 
    end
    
    -- Escolhe uma aleatória
    local escolhida = unicas[math.random(1, #unicas)]
    
    -- Simula clique usando coordenadas na tela
    local sucesso = false
    pcall(function()
        local absPos = escolhida.AbsolutePosition
        local absSize = escolhida.AbsoluteSize
        local clickX = absPos.X + absSize.X / 2
        local clickY = absPos.Y + absSize.Y / 2
        
        -- Mouse button down
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
        task.wait(0.05)
        -- Mouse button up
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
        task.wait(0.05)
        
        sucesso = true
    end)
    
    return sucesso
end

local palavrasPT = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Ao", "Ar", "As", "At", "Ah", "Ai", "Al", "Am", "An",
        "Da", "De", "Di", "Do", "Du", "Em", "Eu", "Ex", "Eh", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Fim", "Ha", "He", "Hi", "Ho", "Hu", "Hyd", "Hyn",
        "Ia", "Io", "Ir", "Is", "It", "Iu", "Ing", "Ingl",
        "Ja", "Je", "Ji", "Jo", "Ju",
        "Ka", "Ke", "Ki", "Ko", "Ku", "La", "Le", "Li", "Lo", "Lu", "Lua", "Ly", "Lyc",
        "Ma", "Me", "Mi", "Mo", "Mu", "Mar", "Mao", "Mel", "Mau",
        "Na", "Ne", "Ni", "No", "Nu", "Nao", "Nos", "Ny", "Nyl",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Paz", "Pau", "Pe", "Ps", "Psi",
        "Ra", "Re", "Ri", "Ro", "Ru", "Rua", "Rio", "Ria",
        "Sa", "Se", "Si", "So", "Su", "Sol", "Sim", "Sou", "Sal", "Es", "Esv",
        "Ta", "Te", "Ti", "To", "Tu", "Tal", "Tao",
        "Ua", "Ui", "Um", "Uns", "Uma", "Umas", "Ur",
        "Va", "Ve", "Vi", "Vo", "Vu", "Vai", "Vem", "Viu", "Vos",
        "Xa", "Xe", "Xi", "Xo", "Xu", "Xis",
        "Yu", "Yun", "Yur",
        "Za", "Ze", "Zi", "Zo", "Zu",
        "Ost", "Ox", "Os",
        "Epi", "Epo", "Epa"
    },
    ["COMPLETAS"] = {
        "Amor", "Amigo", "Agua", "Arvore", "Abacate", "Alegria", "Animal", "Anjo", "Alma", "Ave", "Ato", "Amante", "Aluno", "Aluna", "Aula", "Alto", "Antes", "Assim", "Ano", "Amo", "Ama", "Areia", "Azeitona",
        "Andar", "Andante", "Andorinha", "Andaime", "Andiroba", "Android", "Androide", "Andrada", "Andre", "Andrea", "Androceu", "Androgeno", "Andragogia",
        "Aha", "Ahahah", "Aham", "Ahazar",
        "Angulo", "Angustia", "Anglicano", "Angola", "Angolano", "Angra", "Angu", "Angustiar", "Angustiado", "Angelical", "Angina", "Angiologia",
        "Bola", "Boneca", "Bala", "Bolo", "Bebe", "Boca", "Braco", "Branco", "Bomba", "Brisa", "Beleza", "Batata", "Banana", "Bicicleta", "Boi", "Bau", "Bem", "Bom",
        "Casa", "Carro", "Cama", "Cachorro", "Ceu", "Copo", "Carta", "Cinto", "Cego", "Coxa", "Cor", "Cadeira", "Cavalo", "Cobra", "Cozinha", "Cao", "Com", "Cem",
        "Chave", "Chuva", "Chao", "Chama", "Chocolate", "Choro", "Chumbo", "Chique", "Chinelo", "Charme", "Churrasco", "Chaveiro", "Chamine", "Chiclete",
        "Clemente", "Clerigo", "Cleopatra", "Clerical", "Clero", "Clematite", "Clemencia",
        "Certo", "Certeza", "Certificar", "Cercar", "Cerco", "Cerca", "Cerimonia", "Ceramica", "Cerebro", "Cereal", "Cereja", "Cerrado",
        "Dado", "Dedo", "Doce", "Dente", "Dia", "Deus", "Danca", "Dor", "Duna", "Dica", "Dom", "Dinheiro", "Diamante", "Duvida", "Dar", "Dez",
        "Editar", "Editor", "Edicao", "Edificio", "Edital", "Edipo", "Edredom", "Educar", "Educado", "Educacao", "Edem", "Edema", "Eden", "Edentado",
        "Escola", "Estrela", "Elefante", "Escada", "Emo", "Erva", "Eixo", "Eco", "Etica", "Era", "Esperanca", "Espada", "Espelho", "Estrada", "Ela", "Ele", "Eles", "Elas",
        "Esvair", "Esvaziar", "Esvaziado", "Esverdear", "Esverdinhado", "Esvoacar", "Esvoacante", "Esvanecer", "Esvanecido", "Esvanecimento", "Esvaido", "Esvaida",
        "Epoca", "Epico", "Epica", "Epicos", "Epicas", "Episodio", "Episodios", "Episcopal", "Episcopalismo", "Epistemologia", "Epistemologico", "Epitafio", "Epitafios", "Epiteto", "Epitetos", "Epopeia", "Epopeias", "Epico", "Epidemia", "Epidemias", "Epidemiologia", "Epidemico", "Epiderme", "Epifania", "Epifanias", "Epigrafe", "Epigrafes", "Epilepsia", "Epileptico", "Epilogo", "Epilogos", "Epinicio", "Epinicios", "Episcopal", "Episodico", "Episodicamente", "Epistola", "Epistolas", "Epistolar", "Epitaxial", "Epitelio", "Epitelial", "Epitomar", "Epitomado", "Epitome", "Epitomes", "Eponimo", "Eponimos", "Epoptico", "Epopticos", "Epsilon", "Epsilons", "Epulide", "Epulides", "Epopeico", "Epidemico", "Epidermico", "Epigastrico", "Epigenetico", "Epiglote", "Epiglotico", "Epigrafico", "Epilatorio", "Epileptiforme", "Epilogal", "Epilogistico", "Epimorfose", "Epinefrina", "Epipaleolitico", "Epiploon", "Epirrematico", "Episcopado", "Episiotomia", "Epistemico", "Epistilbite", "Epistolarmente", "Epitaxia", "Epitaxico", "Epitelial", "Epitelioma", "Epiteliomatoso", "Epitematico", "Epitermico", "Epiteto", "Epitimia", "Epitimo", "Epitomacao", "Epitomador", "Epitomar", "Epitomista", "Epitomizar", "Epitopo", "Epitopos", "Epitroclea", "Epitroclear", "Epitropo", "Epitropismo", "Epixilo", "Epixilos", "Epizootia", "Epizootico", "Epo", "Epos", "Epodo", "Epodos", "Eponimo", "Eponimia", "Eponimico", "Epopeia", "Epopeico", "Epoptia", "Epoptas", "Epopteia", "Eporo", "Eporos",
        "Faca", "Festa", "Fogo", "Flor", "Frio", "Fome", "Forte", "Fe", "Fuga", "Fase", "Fim", "Fazenda", "Foguete", "Fronteira", "Foz", "Fez",
        "Gato", "Gelo", "Gota", "Gol", "Grande", "Grato", "Gente", "Grito", "Grama", "Gula", "Garfo", "Garagem", "Gaveta", "Girassol", "Gas",
        "Hora", "Hotel", "Hino", "Habilidade", "Harpa", "Haste", "Hiena", "Humor", "Homem", "Honra",
        "Hidratar", "Hidratado", "Hidratacao", "Hidratante", "Hidraulica", "Hidraulico", "Hidrografia", "Hidrografico", "Hidrologia", "Hidrologico", "Hidrometro", "Hidroponia", "Hidrosfera", "Hidroterapia", "Hidrovia", "Hidroviario", "Hidrogenio", "Hidrogenar", "Hidroaviao", "Hidroeletrica", "Hidreletrica", "Hidrocefalia", "Hidrofobia", "Hidrofobico", "Hidrofilo", "Hidrofugo", "Hidromassagem", "Hidroplanagem", "Hidropico", "Hidrostatica",
        "Igreja", "Ilha", "Ima", "Inseto", "Idade", "Idolo", "Irado", "Impar", "Indio", "Irmao", "Irma", "Ir", "Ia", "Iate", "Iara",
        "Ingles", "Inglesa", "Ingleses", "Inglesas", "Inglaterra", "Ingle", "Inglesinha", "Inglesismo", "Inglesar", "Inglesado",
        "Isolar", "Isolado", "Isolante", "Isopor", "Isotopo", "Isqueiro", "Isso", "Isto", "Israel", "Isabel", "Ismael", "Isidoro", "Isento", "Isencao", "Islandia", "Islamismo", "Islamita",
        "Inerte", "Inercia", "Inedito", "Inepto", "Inexato", "Inefavel", "Inegavel", "Inesquecivel",
        "Ionico", "Ionizacao", "Ionizar", "Ionizado", "Ionizante", "Ionizador", "Iones", "Ionica", "Ionicos", "Ionicas",
        "Janela", "Jogo", "Jato", "Joia", "Jovem", "Junto", "Janta", "Jaz", "Juba", "Jardim", "Jornal", "Jogador", "Jus",
        "Kaki", "Karma", "Kart", "Kebab", "Ketchup", "Kilo", "Kit", "Kiwi", "Kaiser", "Karaoke", "Karate", "Kayak", "Kimono", "Kiosque", "Koala", "Kombi",
        "Lata", "Leao", "Lua", "Livro", "Lindo", "Largo", "Leite", "Lousa", "Lince", "Lixo", "Laranja", "Limao", "Luzes", "Luz", "Ler", "Leu",
        "Lyceu", "Lyceus", "Lyceista", "Lyceal", "Lycan", "Lycans", "Lycanthro", "Lycanthropia", "Lycanthropico", "Lycopene", "Lycopeno", "Lycopodium", "Lycoris", "Lycosa", "Lycosidae",
        "Mala", "Mao", "Mesa", "Moto", "Mundo", "Morto", "Muito", "Monge", "Mamilo", "Moca", "Macaco", "Madeira", "Mochila", "Moeda", "Mas", "Meu", "Meus",
        "Myrra", "Myrtilo", "Myrmeologia", "Myriade", "Myriapode", "Myrica", "Myrtaceas", "Myrtiformes", "Myrmecofago", "Myrmecologia",
        "Mente", "Mental", "Mentir", "Mentira", "Mentor", "Mencao", "Menino", "Menina", "Menor", "Mensal", "Mensagem", "Mencionar", "Mentol", "Mentiroso",
        "Nada", "Nave", "Ninho", "Nove", "Noite", "Nobre", "Norte", "Nexo", "Nata", "Nuca", "Navio", "Noticia", "Novela", "Nem", "Num",
        "Nylon", "Nylons", "Ninfa", "Ninfas", "Ninfeta", "Ninfomania", "Ninfeia", "Ninfeu", "Niquel", "Niquelar",
        "Ovo", "Olho", "Ouro", "Osso", "Ontem", "Ordem", "Oeste", "Oleo", "Onda", "Orgao", "Ovelha", "Oculos", "Orelha", "Onde",
        "Ostra", "Ostras", "Ostentar", "Ostentacao", "Ostensivo", "Ostensao", "Ostentador", "Ostentoso", "Osteologia", "Osteologista", "Osteoporose", "Osteoartrite",
        "Oxford", "Oxigenio", "Oxigenar", "Oxidar", "Oxidacao", "Oxidante", "Oxido", "Oxala", "Oxente", "Oxigenado",
        "Oscar", "Oscilar", "Oscilacao", "Oscilante", "Osciloscopio", "Osculo", "Oscular",
        "Otimo", "Otima", "Otimismo", "Otimista", "Otimizar", "Otite", "Otorrino", "Otorrinolaringologista", "Otario", "Otica", "Otico", "Otomano", "Otomanos", "Otoridade",
        "Adocao", "Adotar", "Adotivo", "Adotado", "Adorar", "Adoracao", "Adoravel", "Adolescente", "Adormecer", "Adormentado", "Adocicar", "Adocicado", "Adoidado", "Adorar", "Adorador",
        "Pato", "Peixe", "Pena", "Pote", "Porta", "Pedra", "Prato", "Presa", "Pombo", "Preto", "Palavra", "Pessoa", "Pequeno", "Problema", "Programa", "Presente", "Professor", "Pipoca", "Pirata", "Por", "Pos",
        "Psicologia", "Psicologo", "Psicologa", "Psique", "Psicose", "Psicopata", "Psicanalise", "Psicoterapia", "Psicodelico", "Pseudonimo", "Pseudociencia", "Pseudoartrose",
        "Pyrata", "Pyro", "Pyrometro", "Python",
        "Queijo", "Quadro", "Quarto", "Quente", "Quase", "Querer", "Queda", "Queixo", "Quilo", "Quadrado", "Quarenta", "Quilometro", "Quintal", "Quinze", "Que", "Quem",
        "Rato", "Rede", "Rio", "Roda", "Roupa", "Rico", "Rapido", "Rima", "Roxo", "Rugby", "Relogio", "Remedio", "Riqueza", "Rir",
        "Sapo", "Sino", "Sol", "Suco", "Sala", "Santo", "Sorte", "Selva", "Seta", "Sim", "Sistema", "Semente", "Segredo", "Sentido", "Silencio", "Sorvete", "Sombra", "Saudade", "Sapato", "Ser", "Seu", "Seus",
        "Syntese", "Synfonia", "Synonimo", "Syntoma", "Synchronia",
        "Skate", "Ski", "Sketch",
        "Tatu", "Tela", "Teto", "Tigre", "Terra", "Tempo", "Tudo", "Trono", "Tora", "Tufo", "Trabalho", "Telefone", "Tamanho", "Tesoura", "Tomate", "Tenis", "Tigela", "Tartaruga", "Ter", "Teu", "Teus", "Tua", "Tuas",
        "Uva", "Urso", "Unha", "Uno", "Ultimo", "Unico", "Urgente", "Utero", "Urano",
        "Vaca", "Vela", "Vento", "Vidro", "Velho", "Verde", "Vida", "Vulcao", "Valsa", "Vulto", "Viagem", "Vizinho", "Vassoura", "Vestido", "Vez", "Ver",
        "Wafer", "Waffle", "Walkman", "Water", "Watt", "Web", "Weekend", "Western", "Whatsapp", "Whisky", "Wi-fi", "Windsurf", "Wok", "Workshop", "World", "Wow",
        "Xadrez", "Xarope", "Xerife", "Xerox", "Xicara", "Xingo", "Xixi", "Xodo", "Xucro", "Xenon", "Xereta", "Xampu", "Xale", "Xara", "Xavante", "Xisto",
        "Yakisoba", "Yakult", "Yamaha", "Yard", "Yen", "Yin", "Yoga", "Yogurt", "Youtube", "Yuca", "Yugoslavia", "Yugoslavo", "Yuri", "Yuta",
        "Zebra", "Zero", "Zangado", "Ziper", "Zona", "Zoo", "Zumbi",
        -- NOVAS PALAVRAS PT (+300)
        "Abacaxi", "Abelha", "Abismo", "Abobora", "Abrigo", "Absurdo", "Academia", "Acai", "Acento", "Achar", "Aco", "Acordar", "Acre", "Acucar", "Adaga", "Adivinha", "Advogado", "Aeroporto", "Afeto", "Agenda", "Agonia", "Agosto", "Agudo", "Album", "Alcachofra", "Alcaparra", "Aldeia", "Alecrim", "Alface", "Alfaiate", "Algodao", "Alho", "Alias", "Alien", "Alimento", "Alivio", "Almoco", "Altar", "Alto", "Aluguel", "Alvo", "Amarelo", "Ambiente", "Ameixa", "Amendoim", "Amido", "Amnesia", "Amora", "Ampulheta", "Anao", "Ancora", "Anel", "Anfibio", "Angu", "Anil", "Aniversario", "Antena", "Antigo", "Antonio", "Anuncio", "Aparelho", "Aperto", "Apice", "Apito", "Apolo", "Aposta", "Apressar", "Aquario", "Aranha", "Area", "Areia", "Argila", "Aroma", "Arroz", "Arte", "Artesao", "Asa", "Asfalto", "Aspirador", "Astro", "Ateu", "Atlanta", "Atlas", "Atleta", "Atum", "Audiencia", "Aurora", "Autor", "Avenida", "Avestruz", "Aviso", "Avo", "Azar", "Azedo", "Azul",
        "Baba", "Babado", "Bacia", "Bacon", "Bacteria", "Bagagem", "Bagre", "Bairro", "Baixar", "Balao", "Balde", "Baleia", "Bambu", "Banco", "Bandido", "Bandeira", "Banho", "Banquete", "Bar", "Barata", "Barba", "Barco", "Barriga", "Barro", "Base", "Bastao", "Batom", "Bau", "Bebe", "Beber", "Bege", "Beijo", "Beira", "Bencao", "Bercario", "Berinjela", "Beterraba", "Bexiga", "Biblia", "Bicho", "Bilhete", "Biologia", "Biscoito", "Bisturi", "Bloco", "Blusa", "Bobina", "Bode", "Bola", "Boleto", "Bolha", "Bolo", "Bolsa", "Bomba", "Bonde", "Bone", "Borda", "Borracha", "Bosque", "Bota", "Botao", "Bote", "Briga", "Brilho", "Broca", "Broche", "Bruxa", "Bufalo", "Bule", "Buraco", "Burocracia", "Busca", "Bussola",
        -- Palavras com EP em PT
        "Epidemiologico", "Epidemiologista", "Epidermico", "Epifitico", "Epigenese", "Epigenetico", "Epiglotal", "Epiglotico", "Epigrafico", "Epilatorio", "Epileptico", "Epileptogenico", "Epileptologista", "Epilogacao", "Epilogal", "Epilogar", "Epilogismo", "Epilogistico", "Epimorfose", "Epimorfo", "Epinefrina", "Epinicio", "Epinicios", "Epiploico", "Epiploon", "Epiploplastia", "Episcopal", "Episcopalismo", "Episcopalista", "Episcopisa", "Episiotomia", "Episodico", "Episodicamente", "Episodio", "Epistaxe", "Epistemologia", "Epistemologico", "Epistemologista", "Epistemico", "Epistilbite", "Epistola", "Epistolar", "Epistolarmente", "Epistolografo", "Epistomio", "Epistomo", "Epitalamio", "Epitalamo", "Epitaxia", "Epitaxico", "Epitelial", "Epitelio", "Epitelioma", "Epiteliomatoso", "Epitematico", "Epitemia", "Epitermico", "Epiteto", "Epitimia", "Epitimo", "Epitomar", "Epitomado", "Epitomador", "Epitomista", "Epitomizacao", "Epitomizar", "Epitopo", "Epitroclea", "Epitroclear", "Epitrocleite", "Epitropo", "Epitropismo", "Epixilo", "Epizootia", "Epizootico", "Epodo", "Epopeia", "Epopeico", "Epoptico", "Epopteia", "Epulide", "Epulotico", "Epulozoo", "Epuracao", "Epurar", "Epurado"
    }
}

local palavrasEN = {
    ["CURTAS"] = {
        "A", "I", "O", "Y", "Am", "An", "As", "At", "Ah", "Ai", "Al", "Ar", "Ax",
        "Be", "By", "Bo", "Bi", "Co", "Ca", "Ce", "Ci", "Cu",
        "Do", "Da", "De", "Di", "Du", "Em", "El", "Es", "Ex", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Go", "Ga", "Ge", "Gi", "Gu",
        "Ha", "He", "Hi", "Ho", "Hu", "Hyd", "Hyn",
        "If", "In", "Is", "It", "Ing", "Ingl",
        "La", "Le", "Li", "Lo", "Lu", "Ly", "Lyc",
        "Ma", "Me", "Mi", "Mo", "Mu", "My",
        "Na", "Ne", "Ni", "No", "Nu", "Ny", "Of", "Oh", "Oi", "Ok", "On", "Or", "Os", "Ow", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Ps", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Sh", "Si", "So", "St", "Su", "Ta", "Te", "Th", "Ti", "To", "Tu",
        "Um", "Un", "Up", "Us", "Va", "Ve", "Vi", "Vo", "Vu",
        "Wa", "We", "Wi", "Wo", "Wu", "Xe", "Xi", "Xu", "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu",
        "Es", "Esv",
        "Ost", "Ox", "Os",
        "Epi", "Epo"
    },
    ["COMPLETAS"] = {
        "Ace", "Act", "Add", "Age", "Ago", "Aid", "Aim", "Air", "All", "And", "Ant", "Any", "Ape", "Arc", "Are", "Ark", "Arm", "Art", "Ash", "Ask", "Ate", "Awe", "Axe",
        "Android", "Andes", "Andrew", "Andy", "Andesite", "Androgen", "Androgyny", "Andean", "Andromeda", "Andante", "Andiron",
        "Aha", "Aham", "Ahankara", "Ahaaina",
        "Angel", "Anger", "Angle", "Angry", "Angus", "Angola", "Angolan", "Anglican", "Angst", "Anguish", "Angelfish", "Angelica", "Angelic", "Angina", "Angiogram", "Angioplasty", "Angiosperm",
        "Bad", "Bag", "Ban", "Bar", "Bat", "Bay", "Bed", "Bet", "Bid", "Big", "Bin", "Bit", "Bog", "Bow", "Box", "Boy", "Bud", "Bug", "Bun", "Bus", "But", "Buy",
        "Cab", "Cam", "Can", "Cap", "Car", "Cat", "Cop", "Cow", "Cry", "Cub", "Cup", "Cur", "Cut",
        "Certain", "Certainly", "Certify", "Certificate", "Cereal", "Ceremony", "Ceramic", "Cerulean", "Cerberus", "Cerebral", "Cerebrum", "Cervical", "Cervix",
        "Clean", "Clear", "Clearly", "Cleat", "Cleats", "Cleave", "Cleaver", "Clef", "Clefs", "Cleft", "Clemency", "Clement", "Clench", "Clergy", "Cleric", "Clerical", "Clerk", "Clever", "Clew",
        "Dad", "Dam", "Day", "Den", "Dew", "Did", "Dig", "Dim", "Dip", "Dog", "Dot", "Dry", "Dug", "Duo", "Dye",
        "Edit", "Edited", "Editing", "Edition", "Editor", "Editorial", "Educate", "Educated", "Education", "Educe", "Educt", "Eddy", "Eddies", "Edge", "Edged", "Edges", "Edging", "Edgy", "Edible", "Edict", "Edifice", "Edify", "Edison", "Edmonton", "Edna", "Edsel", "Edward",
        "Ear", "Eat", "Eel", "Egg", "Elf", "Elm", "Emu", "End", "Era", "Eve", "Eye",
        "Eschew", "Eschewed", "Eschewing", "Escort", "Escorted", "Escorting", "Especial", "Especially", "Espouse", "Espoused", "Espousing", "Esquire", "Essay", "Essays", "Essence", "Essences", "Essential",
        "Epic", "Epics", "Epoch", "Epochs", "Epode", "Epodes", "Eponym", "Eponyms", "Eponymous", "Epopee", "Epopees", "Epos", "Epoxy", "Epoxies", "Epsilon", "Epsilons", "Epicene", "Epicenes", "Epicenter", "Epicenters", "Epicentral", "Epicure", "Epicures", "Epicurean", "Epicureanism", "Epicycle", "Epicycles", "Epicyclic", "Epicycloid", "Epicycloidal", "Epidemic", "Epidemics", "Epidemical", "Epidemiologic", "Epidemiological", "Epidemiologist", "Epidemiology", "Epidermic", "Epidermis", "Epidermoid", "Epidiascope", "Epididymis", "Epididymitis", "Epidote", "Epidotes", "Epidural", "Epifocal", "Epigamic", "Epigastric", "Epigastrium", "Epigeal", "Epigene", "Epigenesis", "Epigenetic", "Epigenetics", "Epigenous", "Epigeous", "Epiglottal", "Epiglottic", "Epiglottis", "Epigone", "Epigones", "Epigonic", "Epigonism", "Epigonous", "Epigram", "Epigrams", "Epigrammatic", "Epigrammatist", "Epigraph", "Epigraphs", "Epigrapher", "Epigraphic", "Epigraphical", "Epigraphist", "Epigraphy", "Epigynous", "Epilation", "Epilate", "Epilated", "Epilating", "Epilation", "Epilator", "Epilators", "Epilepsy", "Epileptic", "Epileptics", "Epileptiform", "Epileptogenic", "Epileptologist", "Epileptology", "Epilimnion", "Epilithic", "Epilog", "Epilogs", "Epilogue", "Epilogues", "Epiloguize", "Epimere", "Epimeres", "Epimeric", "Epimerism", "Epimeron", "Epimorph", "Epimorphic", "Epimorphism", "Epimysium", "Epinephrine", "Epinephrin", "Epineural", "Epineurium", "Epinicion", "Epinikion", "Epinikian", "Epipaleolithic", "Epipetalous", "Epiphania", "Epiphanic", "Epiphanies", "Epiphanous", "Epiphany", "Epiphenomena", "Epiphenomenal", "Epiphenomenon", "Epiphora", "Epiphragm", "Epiphyllous", "Epiphyseal", "Epiphyses", "Epiphysial", "Epiphysis", "Epiphyte", "Epiphytes", "Epiphytic", "Epiphytical", "Epiphytology", "Epiphytotic", "Epiplasm", "Epiplasmic", "Epiplastron", "Epiplocele", "Epiploic", "Epiploon", "Epiplosarcomphalocele", "Epipolic", "Epipolism", "Epipteric", "Epipubis", "Epipubic", "Episcia", "Episcias", "Episcopacy", "Episcopal", "Episcopalian", "Episcopalianism", "Episcopate", "Episcope", "Episcopes", "Episcopicide", "Episcotister", "Episematic", "Episepalous", "Episiotomy", "Episode", "Episodes", "Episodic", "Episodical", "Episodically", "Epispadias", "Epispastic", "Episperm", "Epispermic", "Epistasis", "Epistatic", "Epistaxis", "Episteme", "Epistemes", "Epistemic", "Epistemically", "Epistemological", "Epistemologically", "Epistemologist", "Epistemology", "Episternal", "Episternum", "Epistilbite", "Epistles", "Epistolar", "Epistolary", "Epistoler", "Epistolic", "Epistolical", "Epistolist", "Epistolographer", "Epistolographic", "Epistolographist", "Epistolography", "Epistoma", "Epistomal", "Epistome", "Epistomial", "Epistrophe", "Epistropheus", "Epistyle", "Epistylis", "Epitaph", "Epitaphs", "Epitapher", "Epitaphian", "Epitaphic", "Epitaphist", "Epitasis", "Epitaxial", "Epitaxic", "Epitaxy", "Epitendineum", "Epithalamia", "Epithalamic", "Epithalamion", "Epithalamium", "Epithalamus", "Epithalline", "Epitheca", "Epithecal", "Epithelia", "Epithelial", "Epithelioid", "Epithelioma", "Epitheliomatous", "Epithelium", "Epithem", "Epithema", "Epithetic", "Epithets", "Epithetize", "Epithite", "Epithyme", "Epithymetic", "Epithymetical", "Epitomator", "Epitome", "Epitomes", "Epitomic", "Epitomical", "Epitomist", "Epitomization", "Epitomize", "Epitomized", "Epitomizer", "Epitomizing", "Epitonic", "Epitope", "Epitopes", "Epitoxoid", "Epitrichium", "Epitrochlea", "Epitrochlear", "Epitrochoid", "Epitrochoidal", "Epitropic", "Epitropism", "Epitropy", "Epixylous", "Epizoan", "Epizoic", "Epizoism", "Epizoon", "Epizootic", "Epizootics", "Epizootiology", "Epizooty",
        "Fan", "Far", "Fat", "Fax", "Fed", "Few", "Fig", "Fin", "Fir", "Fit", "Fix", "Fly", "Fog", "For", "Fox", "Fry", "Fun", "Fur",
        "Gag", "Gap", "Gas", "Get", "Gig", "Gin", "God", "Got", "Gum", "Gun", "Gut", "Guy", "Gym",
        "Had", "Ham", "Has", "Hat", "Hay", "Hen", "Her", "Hew", "Hid", "Him", "Hip", "His", "Hit", "Hog", "Hop", "Hot", "How", "Hub", "Hue", "Hug", "Hum", "Hut",
        "Hydrate", "Hydrated", "Hydrating", "Hydration", "Hydrant", "Hydrants", "Hydraulic", "Hydraulics", "Hydrogen", "Hydrography", "Hydrology", "Hydrologic", "Hydrometer", "Hydroponic", "Hydroponics", "Hydrosphere", "Hydrotherapy", "Hydroplane", "Hydroelectric", "Hydrocephalus", "Hydrophobia", "Hydrophobic", "Hydrophilic", "Hydrofuge", "Hydromassage", "Hydroplaning", "Hydrostatic", "Hydropower",
        "Ice", "Icy", "Icon", "Icky", "Idea", "Idle", "Idol", "Inch", "Into", "Iron", "Isle", "Issue", "Item", "Itch", "Itchy",
        "Ingle", "Ingles", "Inglenook", "Inglorious", "Ingloriously", "Ingluvies", "Ingluvious",
        "Island", "Isle", "Isolate", "Isolated", "Isolation", "Isolator", "Isomer", "Isotope", "Isotonic", "Isosceles", "Israel", "Israeli", "Isaac", "Isaiah", "Isabel", "Isabella", "Ishtar", "Isis", "Islam", "Islamic", "Islamist",
        "Inert", "Inertia", "Inevitable", "Inexact", "Inept", "Inequality", "Ineffable", "Inelegant",
        "Ion", "Ions", "Ionic", "Ionize", "Ionized", "Ionizing", "Ionization", "Ionosphere", "Ionospheric", "Iona", "Ione", "Ionian", "Ionicity",
        "Jab", "Jag", "Jam", "Jar", "Jaw", "Jay", "Jet", "Jig", "Job", "Jog", "Jot", "Joy", "Jug", "Jut",
        "Keg", "Ken", "Key", "Kid", "Kin", "Kit", "Kite", "Knee", "Knew", "Knit", "Knob", "Knot", "Know", "Keen", "Keep", "Kept", "Kick", "Kill", "Kind", "King", "Kiss",
        "Lab", "Lad", "Lag", "Lap", "Law", "Lay", "Led", "Leg", "Let", "Lid", "Lip", "Lit", "Log", "Lot", "Low",
        "Lyceum", "Lyceums", "Lycee", "Lycees", "Lycan", "Lycans", "Lycanthrope", "Lycanthropy", "Lycopene", "Lycopenes", "Lycopodium", "Lycopods", "Lycoris", "Lycosa", "Lycosidae",
        "Mad", "Man", "Map", "Mat", "Maw", "Men", "Met", "Mid", "Mix", "Mob", "Mod", "Mom", "Mop", "Mow", "Mud", "Mug", "Mum",
        "Myrrh", "Myrtle", "Myrmecology", "Myriad", "Myriapod", "Myrica", "Myrtaceae", "Myrmecologist", "Myrmecophagous", "Myrmidon",
        "Mental", "Mention", "Mentor", "Menthol", "Mentality", "Mentioned", "Mentoring", "Mentorship",
        "Nab", "Nag", "Nap", "Net", "New", "Nil", "Nip", "Nit", "Nod", "Nor", "Not", "Now", "Nut",
        "Nylon", "Nylons", "Nymph", "Nymphs", "Nympho", "Nymphomania", "Nymphomaniac", "Nystagmus", "Nystatin", "Nyx",
        "Oak", "Oar", "Oat", "Odd", "Off", "Oil", "Old", "One", "Opt", "Orb", "Ore", "Our", "Out", "Owl", "Own",
        "Oyster", "Oysters", "Ostentatious", "Ostentation", "Ostensible", "Ostensibly", "Osteopath", "Osteopathy", "Osteoporosis", "Osteoarthritis", "Osteology", "Osteologist",
        "Oxford", "Ox", "Oxen", "Oxide", "Oxides", "Oxidize", "Oxidized", "Oxidizing", "Oxidation", "Oxygen", "Oxygenate", "Oxygenated", "Oximeter", "Oxbow", "Oxcart", "Oxtail", "Oxpecker",
        "Oscar", "Oscillate", "Oscillation", "Oscillator", "Oscilloscope", "Osculum", "Oscular",
        "Other", "Otter", "Ottoman", "Otto", "Otic", "Otitis", "Otoscope", "Otorhinolaryngology", "Otalgia", "Otiose",
        "Adopt", "Adopted", "Adopting", "Adoption", "Adoptive", "Adore", "Adored", "Adoring", "Adoration", "Adorable", "Adolescent", "Adolescence", "Adobe", "Adonis", "Adonize",
        "Pad", "Pal", "Pan", "Paw", "Pea", "Peg", "Pen", "Pet", "Pie", "Pig", "Pin", "Pit", "Pod", "Pop", "Pot", "Pry", "Pub", "Pug", "Pun", "Pup", "Pus", "Put",
        "Psychology", "Psychologist", "Psyche", "Psychosis", "Psychopath", "Psychoanalysis", "Psychotherapy", "Psychedelic", "Pseudonym", "Pseudoscience", "Pseudo",
        "Python", "Pyramid", "Pyre", "Pyro", "Pyrite", "Pyx", "Pyxis", "Pylon", "Pylori",
        "Rag", "Ram", "Ran", "Rat", "Raw", "Ray", "Red", "Rib", "Rid", "Rig", "Rim", "Rob", "Rod", "Rot", "Row", "Rub", "Rug", "Run", "Rut",
        "Sad", "Sag", "Sap", "Sat", "Saw", "Say", "Sea", "Set", "She", "Shy", "Sin", "Sip", "Sir", "Sit", "Six", "Ski", "Sky", "Sly", "Sob", "Son", "Sop", "Sot", "Sow", "Soy", "Spa", "Spy", "Sub", "Sum", "Sun", "Sup",
        "System", "Symbol", "Symptom", "Synergy", "Synthesis", "Synthetic", "Synonym", "Symphony", "Syrup", "Syringe", "Syllable", "Syllabus", "Symmetry", "Sympathy", "Symphonic", "Synapse", "Synopsis", "Syndicate", "Syndrome",
        "Skate", "Skater", "Sketch", "Skeleton", "Skeptic", "Skill", "Skilled", "Skillet", "Skin", "Skinny", "Skip", "Skipper", "Skirt", "Skull", "Skunk", "Sky", "Skylark", "Skyscraper",
        "Share", "Shark", "Sharp", "Shave", "Sheep", "Sheet", "Shell", "Shield", "Shift", "Shine", "Ship", "Shirt", "Shock", "Shoe", "Shoot", "Shop", "Shore", "Short", "Shot", "Shout", "Show", "Shower", "Shrimp", "Shrine",
        "Tab", "Tag", "Tan", "Tap", "Tar", "Tax", "Tea", "Ten", "The", "Tie", "Tin", "Tip", "Toe", "Ton", "Too", "Top", "Tow", "Toy", "Try", "Tub", "Tug", "Two",
        "Urn", "Use", "Van", "Vat", "Vet", "Vow",
        "Wag", "War", "Was", "Wax", "Way", "Web", "Wet", "Who", "Why", "Wig", "Win", "Wit", "Woe", "Wok", "Won", "Woo", "Wow",
        "Yak", "Yam", "Yap", "Yard", "Yarn", "Yawl", "Yawn", "Yea", "Year", "Yearn", "Yeast", "Yell", "Yellow", "Yelp", "Yen", "Yep", "Yes", "Yet", "Yew", "Yield", "Yoga", "Yogurt", "Yoke", "Yolk", "You", "Young", "Your", "Youth",
        "Yuck", "Yucky", "Yule", "Yuletide", "Yum", "Yummy", "Yurt", "Yuan", "Yucca", "Yugoslavia", "Yugoslav", "Yuri", "Yuta",
        "Zap", "Zen", "Zig", "Zip", "Zoo",
        "Xenon", "Xerox", "Xylem", "Xray", "Xrays", "Xmas", "Xenic", "Xeric", "Xenial", "Xenopus", "Xylophone", "Xylophonist", "Xenophobia", "Xerography", "Xylene",
        -- NOVAS PALAVRAS EN (+300)
        "Abandon", "Ability", "Aboard", "Absence", "Absorb", "Abstract", "Academy", "Accent", "Accept", "Access", "Accord", "Account", "Achieve", "Acid", "Acquire", "Action", "Active", "Actual", "Adapt", "Address", "Adjust", "Admire", "Admit", "Adopt", "Adult", "Advance", "Advice", "Affair", "Affect", "Afford", "Afraid", "After", "Again", "Age", "Agent", "Agree", "Ahead", "Aid", "Aim", "Alarm", "Album", "Alert", "Alien", "Align", "Alive", "All", "Alley", "Allow", "Ally", "Almond", "Almost", "Alone", "Along", "Alpha", "Already", "Also", "Alter", "Always", "Amaze", "Amount", "Ample", "Amuse", "Anchor", "Ancient", "Angel", "Anger", "Angle", "Animal", "Ankle", "Announce", "Annual", "Answer", "Anxiety", "Any", "Apart", "Appeal", "Appear", "Apple", "Apply", "Approach", "April", "Area", "Argue", "Arise", "Armor", "Army", "Around", "Arrange", "Arrest", "Arrive", "Arrow", "Article", "Artist", "Ash", "Aside", "Ask", "Asleep", "Aspect", "Assault", "Asset", "Assign", "Assist", "Assume", "Assure", "Athlete", "Atlas", "Atmosphere", "Atom", "Attach", "Attack", "Attain", "Attempt", "Attend", "Attract", "August", "Aunt", "Author", "Autumn", "Avoid", "Awake", "Award", "Aware", "Awesome", "Awful", "Axis"
    }
}

local palavrasES = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Y", "Al", "Am", "An", "Ar", "As", "Ay",
        "Be", "Bi", "Bo", "Bu", "Ca", "Ce", "Ci", "Co", "Cu", "Da", "De", "Di", "Do", "Du",
        "El", "En", "Es", "Ex", "Fa", "Fe", "Fi", "Fo", "Fu",
        "Ga", "Ge", "Gi", "Go", "Gu", "Ha", "He", "Hi", "Ho", "Hu", "Hyd", "Hyn",
        "Ia", "Io", "Ir", "Is", "It", "Ing", "Ingl",
        "La", "Le", "Li", "Lo", "Lu", "Ly", "Lyc",
        "Ma", "Me", "Mi", "Mo", "Mu", "Myr", "My", "Myn",
        "Na", "Ne", "Ni", "No", "Nu", "Ny",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Ps", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Si", "So", "Su", "Ta", "Te", "Ti", "To", "Tu",
        "Un", "Una", "Unas", "Unos", "Va", "Ve", "Vi", "Vo", "Vu",
        "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu",
        "Es", "Esv",
        "Ost", "Ox", "Os",
        "Epi", "Epo"
    },
    ["COMPLETAS"] = {
        "Aceite", "Agua", "Aire", "Alegre", "Alma", "Amigo", "Amor", "Animal", "Arbol",
        "Andar", "Andante", "Andalucia", "Andaluz", "Andamio", "Androide", "Android", "Androgeno", "Andorra", "Andorrano", "Andrajoso",
        "Aha", "Ahahah", "Aham", "Ahazar",
        "Angel", "Angulo", "Angustia", "Anglicano", "Angola", "Angolano", "Anguila", "Angustiar", "Angustiado", "Angelical", "Angina", "Angiologia",
        "Bebe", "Bello", "Beso", "Blanco", "Boca", "Bola", "Brazo", "Brisa", "Bueno", "Buscar",
        "Calor", "Cama", "Carta", "Casa", "Chapa", "Charco", "Chica", "Chico", "Chino", "Chiste", "Chocolate", "Chuleta", "Ciego", "Cielo", "Cine", "Copa", "Cuerpo",
        "Cierto", "Certeza", "Certificar", "Cercar", "Cerco", "Cerca", "Ceremonia", "Ceramica", "Cerebro", "Cereal", "Cereza", "Cerrado",
        "Clemente", "Clero", "Clerigo", "Clerical", "Cleopatra", "Clemencia", "Clematide",
        "Dado", "Danza", "Dedo", "Dia", "Diente", "Dios", "Dolor", "Don", "Dulce", "Duna",
        "Editar", "Editor", "Editorial", "Edicion", "Edificio", "Edicto", "Edipo", "Edredon", "Educar", "Educado", "Educacion", "Eden", "Edema", "Edentado",
        "Eco", "Edad", "Eje", "Elefante", "Enano", "Entrar", "Era", "Escuela", "Estrella", "Etico",
        "Esvair", "Esvaziar", "Esvaziado", "Esverdear", "Esvoacar", "Esvanecer", "Esvanecido", "Esvaido", "Esvaida",
        "Epoca", "Epico", "Epica", "Epicos", "Epicas", "Episodio", "Episodios", "Episcopal", "Episcopalismo", "Epistemologia", "Epistemologico", "Epitafio", "Epitafios", "Epiteto", "Epitetos", "Epopeia", "Epopeias", "Epopeya", "Epopeyas", "Epidemia", "Epidemias", "Epidemiologia", "Epidemico", "Epidermis", "Epifania", "Epifanias", "Epigrafe", "Epigrafes", "Epilepsia", "Epileptico", "Epilogo", "Epilogos", "Episcopal", "Episodico", "Episodicamente", "Epistola", "Epistolas", "Epistolar", "Epitaxial", "Epitelio", "Epitelial", "Epitomar", "Epitomado", "Epitome", "Epitomes", "Eponimo", "Eponimos", "Epoptico", "Epopticos", "Epsilon", "Epsilones", "Epulide", "Epulides", "Epopeico", "Epidemico", "Epidermico", "Epigastrico", "Epigenetico", "Epiglote", "Epiglotico", "Epigrafico", "Epilatorio", "Epileptiforme", "Epilogal", "Epilogistico", "Epimorfosis", "Epinefrina", "Epipaleolitico", "Epiploon", "Epirrematico", "Episcopado", "Episiotomia", "Epistemico", "Epistilbite", "Epistolarmente", "Epitaxia", "Epitaxico", "Epitelial", "Epitelioma", "Epiteliomatoso", "Epitematico", "Epitermico", "Epiteto", "Epitimia", "Epitimo", "Epitomacion", "Epitomador", "Epitomar", "Epitomista", "Epitomizar", "Epitopo", "Epitroclea", "Epitroclear", "Epitropo", "Epitropismo", "Epixilo", "Epizootia", "Epizootico", "Epo", "Epos", "Epodo", "Epodos", "Eponimo", "Eponimia", "Eponimico", "Epopeico", "Epoptia", "Epoptas", "Epopteia", "Eporo", "Epidemiologico", "Epidemiologista", "Epifitico", "Epigenesis", "Epigenetico", "Epiglotal", "Epiglotico", "Epigrafico", "Epilatorio", "Epileptico", "Epileptogenico", "Epileptologo", "Epilogacion", "Epilogal", "Epilogar", "Epilogismo", "Epilogistico", "Epimorfosis", "Epimorfo", "Epinefrina", "Epinicio", "Epiploico", "Epiploon", "Epiploplastia", "Episcopal", "Episcopalismo", "Episcopalista", "Episcopisa", "Episiotomia", "Episodico", "Episodicamente", "Episodio", "Epistaxis", "Epistemologia", "Epistemologico", "Epistemologo", "Epistemico", "Epistilbite", "Epistola", "Epistolar", "Epistolarmente", "Epistolografo", "Epistomio", "Epistomo", "Epitalamio", "Epitalamo", "Epitaxia", "Epitaxico", "Epitelial", "Epitelio", "Epitelioma", "Epiteliomatoso", "Epitematico", "Epitemia", "Epitermico", "Epiteto", "Epitimia", "Epitimo", "Epitomar", "Epitomado", "Epitomador", "Epitomista", "Epitomizacion", "Epitomizar", "Epitopo", "Epitroclea", "Epitroclear", "Epitrocleitis", "Epitropo", "Epitropismo", "Epixilo", "Epizootia", "Epizootico", "Epodo", "Epopeya", "Epopeico", "Epoptico", "Epopteia", "Epulide", "Epulotico", "Epulozoo", "Epuracion", "Epurar", "Epurado",
        "Fama", "Fase", "Fe", "Fiesta", "Fin", "Flor", "Foca", "Frio", "Fuego", "Fuga",
        "Gato", "Gente", "Gol", "Gota", "Grama", "Grande", "Grato", "Grito", "Gula",
        "Habilidad", "Harpa", "Hielo", "Hiena", "Hijo", "Himno", "Hoja", "Hora", "Hotel", "Humor",
        "Hidratar", "Hidratado", "Hidratacion", "Hidratante", "Hidraulica", "Hidraulico", "Hidrografia", "Hidrologia", "Hidrometro", "Hidroponia", "Hidrosfera", "Hidroterapia", "Hidrovia", "Hidrogeno", "Hidroavion", "Hidroelectrica", "Hidrocefalia", "Hidrofobia", "Hidrofilo", "Hidromasaje", "Hidrostatica",
        "Idolo", "Iglesia", "Iman", "India", "Insecto", "Invierno", "Ir", "Isla",
        "Ingles", "Inglesa", "Ingleses", "Inglesas", "Inglaterra", "Ingle", "Inglesismo",
        "Isla", "Islote", "Isleno", "Islandia", "Islandes", "Israel", "Israeli", "Isabel", "Isabela", "Ismael", "Isidro", "Isidoro", "Islam", "Islamico", "Islamista", "Aislar", "Aislado", "Aislante",
        "Inerte", "Inercia", "Inedito", "Inepto", "Inexato", "Inefable", "Inegable", "Inestable",
        "Ionico", "Ionica", "Ionizacion", "Ionizar", "Ionizado", "Ionizante", "Ionizador", "Iones", "Ionio", "Ionia",
        "Jabon", "Jamon", "Jefe", "Jesus", "Jirafa", "Joven", "Joya", "Juego", "Junto",
        "Kilo", "Karma", "Karate", "Kayak", "Kebab", "Ketchup", "Kiwi", "Koala",
        "Largo", "Lata", "Leche", "Leon", "Libro", "Lince", "Lindo", "Loco", "Luna", "Luz",
        "Liceo", "Liceos", "Licantropo", "Licantropia", "Licopeno", "Licopodio", "Licor", "Licores", "Licorera",
        "Madre", "Malo", "Mano", "Mar", "Mesa", "Miel", "Moto", "Mucho", "Muerto", "Mundo",
        "Mirra", "Mirtilo", "Mirmecologia", "Miriada", "Miriapodo", "Mirica", "Mirtaceas", "Mirmecofago", "Mirmidon",
        "Mente", "Mental", "Mentir", "Mentira", "Mentor", "Mencion", "Menor", "Mensual", "Mensaje", "Mencionar", "Mentol",
        "Nada", "Nave", "Nido", "Nieto", "Noble", "Noche", "Norte", "Nube", "Nueve", "Nuez",
        "Nylon", "Nilón", "Ninfa", "Ninfas", "Ninfomania", "Ninfómana", "Ninfea", "Ninfeo", "Niquel", "Niquelar",
        "Obra", "Ocho", "Oeste", "Ojo", "Ola", "Orden", "Oreja", "Oro", "Oso",
        "Ostra", "Ostras", "Ostentar", "Ostentacion", "Ostensible", "Ostentosidad", "Osteologia", "Osteoporosis", "Osteoartritis",
        "Oxford", "Oxigeno", "Oxigenar", "Oxidar", "Oxidacion", "Oxidante", "Oxido", "Oxala", "Oxigenado",
        "Oscar", "Oscilar", "Oscilacion", "Oscilante", "Osciloscopio", "Osculo", "Oscular",
        "Otro", "Otra", "Otros", "Otras", "Otono", "Otomano", "Otomana", "Otomía", "Otorrino", "Otorrinolaringologo", "Otitis", "Otorgar", "Otorgado", "Otoridad",
        "Adoptar", "Adoptado", "Adopcion", "Adoptivo", "Adorar", "Adorado", "Adoracion", "Adorable", "Adolescente", "Adolescencia", "Adobe", "Adonis", "Adonarse",
        "Pan", "Pato", "Paz", "Pena", "Pez", "Piedra", "Piel", "Piso", "Plato", "Puerta",
        "Psicologia", "Psicologo", "Psicologa", "Psique", "Psicosis", "Psicopata", "Psicoanalisis", "Psicoterapia", "Psicodelico", "Pseudonimo", "Pseudociencia",
        "Python", "Piramide", "Pira", "Pirata", "Pirita",
        "Queso", "Quimica", "Quince", "Quitar", "Querer", "Quieto",
        "Rama", "Rapido", "Raton", "Red", "Rey", "Rico", "Rio", "Ropa", "Rosa", "Rueda",
        "Sal", "Santo", "Sapo", "Sed", "Seda", "Selva", "Si", "Silla", "Sol", "Suerte",
        "Sistema", "Simbolo", "Sintoma", "Sinergia", "Sintesis", "Sintetico", "Sinonimo", "Sinfonia", "Sirope", "Jeringa", "Silaba", "Simetria", "Simpatia", "Sinfonico", "Sinapsis", "Sinopsis", "Sindicato", "Sindrome",
        "Skate", "Esqui", "Esqueleto", "Esceptico",
        "Taza", "Techo", "Tela", "Tiempo", "Tierra", "Tigre", "Todo", "Toro", "Tren", "Trono",
        "Una", "Unico", "Union", "Uno", "Urgente", "Uso", "Uva",
        "Vaca", "Valle", "Vaso", "Vela", "Verde", "Vida", "Vidrio", "Viejo", "Viento", "Voz",
        "Exacto", "Examen", "Exito", "Exotico", "Extra", "Flexible", "Texto", "Toxico",
        "Yoga", "Yogurt", "Yate", "Yen", "Yin", "Yegua", "Yelmo", "Yema", "Yermo", "Yerno", "Yeso", "Yodo", "Yuca", "Yugoslavia", "Yugoslavo", "Yunta", "Yute",
        "Zona", "Zoo", "Zapato", "Zanahoria",
        -- NOVAS PALAVRAS ES (+300)
        "Abajo", "Abandonar", "Abanico", "Abierto", "Abogado", "Abrigo", "Abril", "Absoluto", "Absurdo", "Abuela", "Abuelo", "Acabar", "Academia", "Acceso", "Accion", "Aceite", "Acelga", "Acento", "Aceptar", "Acerca", "Acertar", "Acha", "Aclamar", "Aclarar", "Acoger", "Acompanar", "Aconsejar", "Acordar", "Acorde", "Acortar", "Actitud", "Activo", "Actual", "Acuerdo", "Acusar", "Adaptar", "Adelante", "Ademas", "Adentro", "Adios", "Admirar", "Admitir", "Adonde", "Adorno", "Aduana", "Adulto", "Adverso", "Aeropuerto", "Afecto", "Afin", "Afirmar", "Afligir", "Afortunado", "Afrontar", "Afuera", "Agenda", "Agil", "Agitar", "Agonia", "Agosto", "Agotar", "Agradable", "Agredecer", "Agrio", "Agrupar", "Aguacate", "Aguantar", "Aguila", "Aguja", "Ahora", "Ahorrar", "Aire", "Aislar", "Ajedrez", "Ajeno", "Ajustar", "Ala", "Alabar", "Alambre", "Alcance", "Alcanzar", "Alcoba", "Aldea", "Alegrar", "Alejar", "Aleman", "Alentar", "Alfombra", "Algo", "Algodon", "Alguien", "Algun", "Aliado", "Aliento", "Aliviar", "Alla", "Alli", "Alma", "Almacen", "Almendra", "Almohada", "Almorzar", "Almuerzo", "Alojar", "Alquilar", "Alrededor", "Altar", "Altavoz", "Alterar", "Alto", "Altura", "Alumbrar", "Aluminio", "Alzar", "Amable", "Amante", "Amar", "Amargo", "Amarillo", "Ambiente", "Ambos", "Ambulancia", "Amenaza", "Amigo", "Amistad", "Amo", "Amor", "Amplio", "Amuleto", "Anadir", "Analisis", "Anciano", "Ancla", "Ancho", "Andar", "Animal", "Animar", "Animo", "Anoche", "Anotar", "Ansiedad", "Ante", "Antena", "Antes", "Antiguo", "Anual", "Anuncio", "Anzuelo", "Apagar", "Aparato", "Aparente", "Aparte", "Apenas", "Apilar", "Aplastar", "Aplaudir", "Aplicar", "Apodo", "Apoyar", "Apreciar", "Aprender", "Aprobar", "Aprovechar", "Apto", "Apuesta", "Apuntar", "Apurar", "Aquel", "Aqui", "Arado", "Arbitro", "Arbol", "Arder", "Ardiente", "Arena", "Aretes", "Argumento", "Armar", "Armario", "Armonia", "Aroma", "Arquero", "Arrancar", "Arreglar", "Arrepentir", "Arriba", "Arroz", "Arruga", "Arte", "Articulo", "Artista", "Asado", "Ascender", "Aseo", "Asequible", "Asi", "Asiento", "Asignar", "Asilo", "Asistir", "Asno", "Asociar", "Asombrar", "Aspecto", "Aspero", "Astro", "Astuto", "Asumir", "Asunto", "Asustar", "Atar", "Ataud", "Atencion", "Atender", "Atenerse", "Aterrizar", "Atleta", "Atmosfera", "Atonito", "Atorar", "Atraer", "Atrapado", "Atreverse", "Atroz", "Atun", "Audaz", "Audiencia", "Aumento", "Aun", "Aunque", "Aurora", "Ausencia", "Autentico", "Auto", "Autobus", "Autor", "Auxilio", "Avanzar", "Ave", "Avena", "Aventura", "Avergonzar", "Avion", "Avisar", "Avispa", "Avivar", "Ayer", "Ayuda", "Ayunar", "Azafran", "Azar", "Azotea", "Azucar", "Azufre", "Azul"
    }
}

local palavrasPorPrefixo = {
    IC = {"ice", "iced", "ices", "icicle", "icier", "iciest", "icily", "icing", "icky", "ickier", "ickiest", "icon", "icons", "iconic", "icy", "iceland", "iciness", "iceberg", "icone", "icones", "iconico", "iconica", "iconoclasta", "ictericia", "ictiologia", "icaro", "icognita", "ictus", "icono", "iconos"},
    ER = {"era", "erase", "eraser", "erect", "ergo", "erode", "erosion", "err", "error", "errors", "erupt", "eruption", "errand", "erratic", "erroneous", "erudite", "ervilha", "erva", "erguer", "erguido", "ermo", "ermida", "ermitao", "erosao", "erodir", "erudito", "errar", "errado", "erro", "erroneo", "erupcao", "errante", "erguir", "ermitano", "erosionar", "erudicion", "errores", "erupcion", "erizar", "erizo"},
    X = {"xenon", "xerox", "xylem", "xylene", "xylophone", "xylophonist", "xray", "xmas", "xenic", "xeric", "xenial", "xenopus", "xenophobia", "xerography", "xadrez", "xale", "xampu", "xara", "xarope", "xavante", "xeque", "xeques", "xequemate", "xereta", "xerife", "xerocar", "xerocopia", "xexeu", "xicara", "xifopago", "xilogravura", "ximango", "xingo", "xingar", "xinxim", "xiquexique", "xiripiti", "xis", "xisto", "xodo", "xucro", "xenofobia", "xenofobo", "xerocopiar", "xerografia", "xilofono", "xilofonista", "xilografia", "xilografo"},
    LY = {"lynx", "lynxes", "lynch", "lynched", "lynches", "lynching", "lyric", "lyrics", "lyrical", "lyrically", "lyre", "lyres", "lying", "lymph", "lymphatic", "lyra", "lyrio", "lyrios", "lyrica", "lyrico", "lyricas", "lyricos", "lirica", "lirico", "lira", "liras", "liricos", "liricas"},
    GY = {"gym", "gyms", "gypsy", "gypsies", "gyrate", "gyrated", "gyrates", "gyrating", "gyration", "gyro", "gyros", "gyroscope", "gymnast", "gymnasts", "gymnastic", "gymnastics", "gymnastica", "gymnasio", "gymnasios", "gimnasia", "gimnasio", "gimnasios", "gimnasta", "gimnastas", "gimnastica", "giro", "giros", "girar", "girando", "girado", "girada"},
    ANU = {"annual", "annually", "annuity", "annuities", "annul", "annuls", "annular", "annulled", "annulling", "annulment", "anus", "anuses", "anuario", "anuarios", "anuencia", "anuente", "anuentes", "anuir", "anulacao", "anulacoes", "anular", "anulando", "anulado", "anulada", "anulados", "anuladas", "anual", "anuales", "anulacion"},
    PT = {"pterodactyl", "pterodactyls", "pterosaur", "pterosaurs", "ptosis", "ptolemy", "ptyalin", "pteridology", "pterodactilo", "pterodactilos", "ptialina", "ptose"},
    DY = {"dye", "dyed", "dyes", "dyeing", "dying", "dyke", "dykes", "dynamo", "dynamos", "dynamic", "dynamics", "dynamite", "dynamited", "dynasty", "dynasties", "dysentery", "dyslexia", "dyslexic", "dystopia", "dystopian", "dynastia", "dysentería", "dinamita", "dinamo", "dinamos", "dinastia", "dinastias", "dinamico", "dinamica", "dinamicos", "dinamicas", "disenteria", "dislexia", "dislexico", "distopia"},
    CLE = {"clean", "cleaned", "cleaner", "cleaners", "cleanest", "cleaning", "cleanly", "cleanse", "cleansed", "cleanser", "clear", "cleared", "clearer", "clearest", "clearing", "clearly", "cleat", "cleats", "cleave", "cleaved", "cleaver", "cleavers", "clef", "clefs", "cleft", "clefts", "clemency", "clement", "clench", "clenched", "clenches", "clenching", "clergy", "clergyman", "cleric", "clerical", "clerk", "clerks", "clever", "cleverly", "clew", "clews", "clemente", "cleopatra", "clerigo", "clerigos", "clero", "cleros", "clerical", "clericais", "clemencia", "clematite", "clematites"},
    ED = {"edit", "edited", "editing", "edition", "editions", "editor", "editors", "editorial", "editorials", "edmonton", "edna", "edsel", "edward", "eddy", "eddies", "edge", "edged", "edges", "edging", "edgy", "edible", "edict", "edicts", "edifice", "edifices", "edify", "edified", "edifying", "edison", "educate", "educated", "educates", "educating", "education", "educational", "educe", "educed", "educing", "educt", "editar", "editado", "editando", "editores", "editora", "editoras", "edicao", "edicoes", "edificio", "edificios", "edital", "editais", "edipo", "edredom", "educar", "educado", "educada", "educacao", "eden", "edema", "edemas", "edentado", "editorial", "edicion", "edicto", "edredon", "educacion"},
    ION = {"ion", "ions", "ionic", "ionian", "ionians", "ionicity", "ionize", "ionized", "ionizes", "ionizing", "ionization", "ionizations", "ionizer", "ionizers", "ionosphere", "ionospheric", "iona", "ione", "ionium", "ionico", "ionica", "ionicos", "ionicas", "ionizacao", "ionizacoes", "ionizar", "ionizado", "ionizada", "ionizando", "ionizante", "ionizantes", "ionizador", "ionizadores", "iones", "ionizacion", "ionio", "ionia"},
    PY = {"python", "pythons", "pyramid", "pyramids", "pyramidal", "pyre", "pyres", "pyro", "pyrite", "pyrites", "pyx", "pyxis", "pylon", "pylons", "pylori", "pyjamas", "pyrotechnic", "pyromaniac", "pyrata", "pyrometro", "piramide", "pirata", "pirita", "pirotecnica"},
    INE = {"inert", "inertia", "inertial", "inevitable", "inevitably", "inexact", "inexactitude", "inept", "ineptitude", "inequality", "inequalities", "ineffable", "ineffably", "inelegant", "inelegantly", "inerte", "inercia", "inedito", "inedita", "inepto", "inepta", "ineptos", "ineptas", "inexato", "inexata", "inefavel", "inegaveis", "inegavel", "inesquecivel", "inefable", "inegable", "inestable"},
    SY = {"system", "systems", "symbol", "symbols", "symptom", "symptoms", "synergy", "synergies", "synthesis", "synthetic", "synthetics", "synonym", "synonyms", "symphony", "symphonies", "syrup", "syrups", "syringe", "syringes", "syllable", "syllables", "syllabus", "symmetry", "symmetrical", "sympathy", "sympathies", "symphonic", "synapse", "synapses", "synopsis", "syndicate", "syndicates", "syndrome", "syndromes", "syntese", "synteses", "synfonia", "synfonias", "synonimo", "synonimos", "syntoma", "syntomas", "synchronia", "sistema", "sistemas", "simbolo", "simbolos", "sintoma", "sintomas", "sinergia", "sintesis", "sintetico", "sinonimo", "sinonimos", "sinfonia", "sinfonias", "simetria", "simpatia", "sinfonico", "sindicato", "sindrome"},
    MENT = {"mental", "mentally", "mentality", "mentalities", "mention", "mentioned", "mentioning", "mentions", "mentor", "mentors", "mentored", "mentoring", "mentorship", "menthol", "mentholated", "mente", "mentais", "mentir", "mentira", "mentiras", "mentores", "mencao", "mencoes", "menino", "menina", "menor", "menores", "mensal", "mensais", "mensagem", "mensagens", "mencionar", "mencionado", "mentol", "mentiroso", "mentales", "mencion", "menciones", "mensual", "mensuales", "mensaje", "mensajes"},
    SK = {"skate", "skater", "skaters", "skating", "sketch", "sketches", "sketched", "sketching", "skeleton", "skeletons", "skeptic", "skeptical", "skepticism", "skill", "skills", "skilled", "skillet", "skillful", "skin", "skins", "skinny", "skip", "skips", "skipped", "skipping", "skipper", "skirt", "skirts", "skull", "skulls", "skunk", "skunks", "sky", "skies", "skylark", "skyscraper", "skates", "ski", "skis", "esqui", "esquis", "esqueleto", "esqueletos", "esceptico"},
    CER = {"certain", "certainly", "certainty", "certify", "certified", "certifying", "certifies", "certificate", "certificates", "certification", "cereal", "cereals", "ceremony", "ceremonies", "ceremonial", "ceramic", "ceramics", "cerulean", "cerberus", "cerebral", "cerebrum", "cervical", "cervix", "certo", "certa", "certos", "certas", "certeza", "certezas", "certificar", "certificado", "cercar", "cerco", "cercos", "cerca", "cercas", "cerimonia", "cerimonias", "ceramica", "ceramicas", "cerebro", "cerebros", "cereal", "cereais", "cereja", "cerejas", "cerrado", "cierto", "cierta", "ciertos", "ciertas", "ceremonia", "ceremonias", "cereales", "cereza", "cerezas"},
    SH = {"share", "shared", "shares", "sharing", "shark", "sharks", "sharp", "sharpen", "sharpener", "shave", "shaved", "shaving", "sheep", "sheet", "sheets", "shell", "shells", "shelter", "shield", "shields", "shift", "shifted", "shifting", "shine", "shined", "shines", "shining", "shiny", "ship", "ships", "shirt", "shirts", "shock", "shocked", "shocking", "shoe", "shoes", "shoot", "shoots", "shooting", "shop", "shops", "shore", "shores", "short", "shorter", "shortest", "shot", "shots", "shout", "shouted", "shouting", "show", "showed", "shower", "showers", "showing", "shown", "shrimp", "shrimps", "shrine", "shrines", "shampoo", "shopping", "shorts", "champu", "champú", "chocolate", "choque"},
    Y = {"yak", "yaks", "yam", "yams", "yap", "yaps", "yard", "yards", "yarn", "yarns", "yawl", "yawls", "yawn", "yawns", "yea", "yeah", "year", "years", "yearly", "yearn", "yearns", "yeast", "yeasts", "yell", "yells", "yellow", "yellows", "yelp", "yelps", "yen", "yens", "yep", "yes", "yet", "yew", "yews", "yield", "yields", "yoga", "yogurt", "yogurts", "yoke", "yokes", "yolk", "yolks", "you", "young", "younger", "your", "yours", "youth", "youths", "youtube", "yakisoba", "yakult", "yamaha", "yate", "yegua", "yelmo", "yema", "yermo", "yerno", "yeso", "yodo"},
    AND = {"android", "andrew", "andy", "andes", "andesite", "androgen", "androgyny", "andean", "andromeda", "andante", "andiron", "andar", "andorinha", "andaime", "andiroba", "androide", "andrada", "andre", "andrea", "androceu", "androgeno", "andragogia", "andalucia", "andaluz", "andamio", "andorra", "andorrano", "andrajoso"},
    AHA = {"aha", "aham", "ahankara", "ahaina", "ahahah", "ahazar"},
    ANG = {"angel", "anger", "angle", "angry", "angus", "angola", "angolan", "anglican", "angst", "anguish", "angelfish", "angelica", "angelic", "angina", "angiogram", "angioplasty", "angiosperm", "angulo", "angustia", "anglicano", "angolano", "angra", "angu", "angustiar", "angustiado", "angelical", "angiologia", "anguila"},
    OT = {"other", "otter", "ottoman", "otto", "otic", "otitis", "otoscope", "otorhinolaryngology", "otalgia", "otiose", "otimo", "otima", "otimismo", "otimista", "otimizar", "otite", "otorrino", "otorrinolaringologista", "otario", "otica", "otico", "otomano", "otomanos", "otoridade", "otro", "otra", "otros", "otras", "otono", "otomana", "otomía", "otorgar", "otorgado"},
    ADO = {"adopt", "adopted", "adopting", "adoption", "adoptive", "adore", "adored", "adoring", "adoration", "adorable", "adolescent", "adolescence", "adobe", "adonis", "adonize", "adocao", "adotar", "adotivo", "adotado", "adorar", "adoracao", "adoravel", "adormecer", "adormentado", "adocicar", "adocicado", "adoidado", "adorador", "adoptar", "adoptado", "adopcion", "adonarse"},
    IS = {"island", "isle", "isolate", "isolated", "isolation", "isolator", "isomer", "isotope", "isotonic", "isosceles", "israel", "israeli", "isaac", "isaiah", "isabel", "isabella", "ishtar", "isis", "islam", "islamic", "islamist", "isolar", "isolado", "isolante", "isopor", "isotopo", "isqueiro", "isso", "isto", "israel", "isabel", "ismael", "isidoro", "isento", "isencao", "islandia", "islamismo", "islamita", "isla", "islote", "isleno", "islandes", "isabela", "isidro", "aislar", "aislado", "aislante"},
    MYR = {"myrrh", "myrtle", "myrmecology", "myriad", "myriapod", "myrica", "myrtaceae", "myrmecologist", "myrmecophagous", "myrmidon", "myrra", "myrtilo", "myrmeologia", "myriade", "myriapode", "myrtaceas", "myrtiformes", "myrmecofago", "myrmecologia", "mirra", "mirtilo", "mirmecologia", "miriada", "miriapodo", "mirica", "mirtaceas", "mirmecofago", "mirmidon"},
    OST = {"ostrich", "ostracize", "ostracized", "ostracism", "ostensible", "ostensibly", "ostentation", "ostentatious", "osteopath", "osteopathy", "osteoporosis", "osteoarthritis", "osteology", "osteologist", "ostra", "ostras", "ostentar", "ostentacao", "ostensivo", "ostensao", "ostentador", "ostentoso", "osteologia", "osteologista", "osteoporose", "osteoartrite", "ostracismo", "ostracizar", "ostentacion", "ostensible", "ostentosidad", "osteoartritis"},
    YU = {"yuck", "yucky", "yule", "yuletide", "yum", "yummy", "yurt", "yurts", "yuan", "yucca", "yuccas", "yugoslavia", "yugoslav", "yugoslavian", "yuri", "yuta", "yuca", "yugoslavo", "yugoslava", "yunta", "yute", "yodo", "yogurt"},
    NY = {"nylon", "nylons", "nymph", "nymphs", "nympho", "nymphomania", "nymphomaniac", "nystagmus", "nystatin", "nyx", "ninfa", "ninfas", "ninfeta", "ninfetas", "ninfomania", "ninfomaniaca", "ninfeia", "ninfeias", "ninfeu", "ninfeus", "niquel", "niquelar", "niquelado", "nilón", "nilones", "ninfómana"},
    OX = {"ox", "oxen", "oxford", "oxide", "oxides", "oxidize", "oxidized", "oxidizing", "oxidation", "oxidative", "oxygen", "oxygenate", "oxygenated", "oxygenation", "oximeter", "oxbow", "oxbows", "oxcart", "oxcarts", "oxtail", "oxtails", "oxpecker", "oxpeckers", "oxigenio", "oxigenar", "oxigenado", "oxigenada", "oxidar", "oxidacao", "oxidante", "oxidantes", "oxido", "oxidos", "oxala", "oxente", "oxigenacao", "oxigeno", "oxidacion", "oxigenacion"},
    PS = {"psychology", "psychologist", "psyche", "psyches", "psychosis", "psychoses", "psychopath", "psychopaths", "psychoanalysis", "psychotherapy", "psychotherapist", "psychedelic", "psychedelics", "pseudonym", "pseudonyms", "pseudoscience", "pseudo", "psicologia", "psicologo", "psicologa", "psicologos", "psicologas", "psique", "psiques", "psicose", "psicoses", "psicopata", "psicopatas", "psicanalise", "psicoterapia", "psicodelico", "pseudonimo", "pseudonimos", "pseudociencia", "pseudoartrose", "psicosis", "psicoanalisis", "seudociencia"},
    OS = {"oscar", "oscars", "oscillate", "oscillated", "oscillates", "oscillating", "oscillation", "oscillations", "oscillator", "oscillators", "oscilloscope", "oscilloscopes", "osculum", "oscula", "oscular", "oscares", "oscilar", "oscila", "oscilacao", "oscilacoes", "oscilante", "oscilantes", "osciloscopio", "osciloscopios", "osculo", "osculos", "oscilacion"},
    HYD = {
        "hydrate", "hydrated", "hydrates", "hydrating", "hydration", "hydrant", "hydrants", "hydraulic", "hydraulics", "hydraulically", "hydrogen", "hydrogens", "hydrogenate", "hydrogenated", "hydrography", "hydrographic", "hydrology", "hydrologic", "hydrological", "hydrometer", "hydrometers", "hydroponic", "hydroponics", "hydrosphere", "hydrotherapy", "hydroplane", "hydroplaning", "hydroelectric", "hydroelectrical", "hydrocephalus", "hydrophobia", "hydrophobic", "hydrophilic", "hydrofuge", "hydromassage", "hydroplaning", "hydrostatic", "hydrostatics", "hydropower",
        "hidratar", "hidratado", "hidratada", "hidratacao", "hidratante", "hidraulica", "hidraulico", "hidraulicos", "hidrografia", "hidrografico", "hidrologia", "hidrologico", "hidrometro", "hidroponia", "hidrosfera", "hidroterapia", "hidrovia", "hidroviario", "hidrogenio", "hidrogenar", "hidroaviao", "hidroeletrica", "hidreletrica", "hidrocefalia", "hidrofobia", "hidrofobico", "hidrofilo", "hidrofugo", "hidromassagem", "hidroplanagem", "hidropico", "hidrostatica",
        "hidratar", "hidratado", "hidratacion", "hidratante", "hidraulica", "hidraulico", "hidrografia", "hidrologia", "hidrometro", "hidroponia", "hidrosfera", "hidroterapia", "hidrovia", "hidrogeno", "hidroavion", "hidroelectrica", "hidrocefalia", "hidrofobia", "hidrofilo", "hidromasaje", "hidrostatica"
    },
    INGL = {
        "ingle", "ingles", "inglenook", "inglenooks", "inglorious", "ingloriously", "ingluvies", "ingluvious",
        "ingles", "inglesa", "ingleses", "inglesas", "inglaterra", "ingle", "inglesinha", "inglesismo", "inglesar", "inglesado",
        "ingles", "inglesa", "ingleses", "inglesas", "inglaterra", "ingle", "inglesismo"
    },
    LYC = {
        "lyceum", "lyceums", "lycee", "lycees", "lycan", "lycans", "lycanthrope", "lycanthropes", "lycanthropy", "lycanthropic", "lycopene", "lycopenes", "lycopodium", "lycopods", "lycoris", "lycosa", "lycosidae",
        "lyceu", "lyceus", "lyceista", "lyceal", "lycan", "lycans", "lycanthro", "lycanthropia", "lycanthropico", "lycopene", "lycopeno", "lycopodium", "lycoris", "lycosa", "lycosidae",
        "liceo", "liceos", "licantropo", "licantropos", "licantropia", "licopeno", "licopenos", "licopodio", "licopodios", "licor", "licores", "licorera"
    },
    ESV = {
        "eschew", "eschewed", "eschewing", "eschews", "escort", "escorted", "escorting", "escorts", "especial", "especially", "espouse", "espoused", "espouses", "espousing", "esquire", "esquires", "essay", "essays", "essayist", "essayists", "essence", "essences", "essential", "essentially",
        "esvair", "esvairse", "esvaziar", "esvaziado", "esvaziada", "esverdear", "esverdeado", "esverdinhado", "esvoacar", "esvoacante", "esvoacantes", "esvanecer", "esvanecido", "esvanecida", "esvanecimento", "esvaido", "esvaida", "esvaidos", "esvaidas",
        "esvair", "esvaziar", "esvaziado", "esvaziada", "esverdear", "esverdeado", "esvoacar", "esvoacante", "esvanecer", "esvanecido", "esvanecida", "esvaido", "esvaida"
    },
    EP = {
        -- Palavras EP em Português, Inglês e Espanhol
        "epic", "epics", "epoch", "epochs", "epode", "epodes", "eponym", "eponyms", "eponymous", "epopee", "epopees", "epos", "epoxy", "epoxies", "epsilon", "epsilons",
        "epicene", "epicenes", "epicenter", "epicenters", "epicentral", "epicure", "epicures", "epicurean", "epicureanism", "epicycle", "epicycles", "epicyclic", "epicycloid", "epicycloidal",
        "epidemic", "epidemics", "epidemical", "epidemiologic", "epidemiological", "epidemiologist", "epidemiology", "epidermic", "epidermis", "epidermoid", "epidiascope", "epididymis", "epididymitis", "epidote", "epidotes", "epidural",
        "epifocal", "epigamic", "epigastric", "epigastrium", "epigeal", "epigene", "epigenesis", "epigenetic", "epigenetics", "epigenous", "epigeous", "epiglottal", "epiglottic", "epiglottis", "epigone", "epigones", "epigonic", "epigonism", "epigonous",
        "epigram", "epigrams", "epigrammatic", "epigrammatist", "epigraph", "epigraphs", "epigrapher", "epigraphic", "epigraphical", "epigraphist", "epigraphy", "epigynous",
        "epilation", "epilate", "epilated", "epilating", "epilator", "epilators", "epilepsy", "epileptic", "epileptics", "epileptiform", "epileptogenic", "epileptologist", "epileptology", "epilimnion", "epilithic",
        "epilog", "epilogs", "epilogue", "epilogues", "epiloguize", "epimere", "epimeres", "epimeric", "epimerism", "epimeron", "epimorph", "epimorphic", "epimorphism", "epimysium",
        "epinephrine", "epinephrin", "epineural", "epineurium", "epinicion", "epinikion", "epinikian",
        "epipaleolithic", "epipetalous", "epiphania", "epiphanic", "epiphanies", "epiphanous", "epiphany", "epiphenomena", "epiphenomenal", "epiphenomenon", "epiphora", "epiphragm", "epiphyllous", "epiphyseal", "epiphyses", "epiphysial", "epiphysis",
        "epiphyte", "epiphytes", "epiphytic", "epiphytical", "epiphytology", "epiphytotic", "epiplasm", "epiplasmic", "epiplastron", "epiplocele", "epiploic", "epiploon", "epiplosarcomphalocele", "epipolic", "epipolism", "epipteric", "epipubis", "epipubic",
        "episcia", "episcias", "episcopacy", "episcopal", "episcopalian", "episcopalianism", "episcopate", "episcope", "episcopes", "episcopicide", "episcotister",
        "episematic", "episepalous", "episiotomy", "episode", "episodes", "episodic", "episodical", "episodically", "epispadias", "epispastic", "episperm", "epispermic",
        "epistasis", "epistatic", "epistaxis", "episteme", "epistemes", "epistemic", "epistemically", "epistemological", "epistemologically", "epistemologist", "epistemology", "episternal", "episternum", "epistilbite",
        "epistles", "epistolar", "epistolary", "epistoler", "epistolic", "epistolical", "epistolist", "epistolographer", "epistolographic", "epistolographist", "epistolography", "epistoma", "epistomal", "epistome", "epistomial", "epistrophe", "epistropheus", "epistyle", "epistylis",
        "epitaph", "epitaphs", "epitapher", "epitaphian", "epitaphic", "epitaphist", "epitasis", "epitaxial", "epitaxic", "epitaxy", "epitendineum",
        "epithalamia", "epithalamic", "epithalamion", "epithalamium", "epithalamus", "epithalline", "epitheca", "epithecal", "epithelia", "epithelial", "epithelioid", "epithelioma", "epitheliomatous", "epithelium", "epithem", "epithema",
        "epithetic", "epithets", "epithetize", "epithite", "epithyme", "epithymetic", "epithymetical",
        "epitomator", "epitome", "epitomes", "epitomic", "epitomical", "epitomist", "epitomization", "epitomize", "epitomized", "epitomizer", "epitomizing", "epitonic", "epitope", "epitopes", "epitoxoid",
        "epitrichium", "epitrochlea", "epitrochlear", "epitrochoid", "epitrochoidal", "epitropic", "epitropism", "epitropy", "epixylous",
        "epizoan", "epizoic", "epizoism", "epizoon", "epizootic", "epizootics", "epizootiology", "epizooty",
        -- PT
        "epoca", "epico", "epica", "epicos", "epicas", "episodio", "episodios", "episcopal", "epistemologia", "epistemologico", "epitafio", "epitafios", "epiteto", "epitetos", "epopeia", "epopeias", "epidemia", "epidemias", "epidemiologia", "epidemico", "epiderme", "epifania", "epifanias", "epigrafe", "epigrafes", "epilepsia", "epileptico", "epilogo", "epilogos", "epinicio", "epinicios", "episcopal", "episodico", "episodicamente", "epistola", "epistolas", "epistolar", "epitaxial", "epitelio", "epitelial", "epitomar", "epitomado", "epitome", "epitomes", "eponimo", "eponimos", "epoptico", "epopticos", "epsilon", "epsilons", "epulide", "epulides", "epopeico", "epidemico", "epidermico", "epigastrico", "epigenetico", "epiglote", "epiglotico", "epigrafico", "epilatorio", "epileptiforme", "epilogal", "epilogistico", "epimorfose", "epinefrina", "epipaleolitico", "epiploon", "epirrematico", "episcopado", "episiotomia", "epistemico", "epistilbite", "epistolarmente", "epitaxia", "epitaxico", "epitelial", "epitelioma", "epiteliomatoso", "epitematico", "epitermico", "epiteto", "epitimia", "epitimo", "epitomacao", "epitomador", "epitomista", "epitomizar", "epitopo", "epitopos", "epitroclea", "epitroclear", "epitropo", "epitropismo", "epixilo", "epixilos", "epizootia", "epizootico", "epo", "epos", "epodo", "epodos", "eponimo", "eponimia", "eponimico", "epopeia", "epopeico", "epoptia", "epoptas", "epopteia", "eporo", "eporos", "epi", "epo", "epa",
        -- ES
        "epoca", "epico", "epica", "epicos", "epicas", "episodio", "episodios", "episcopal", "epistemologia", "epistemologico", "epitafio", "epitafios", "epiteto", "epitetos", "epopeya", "epopeyas", "epidemia", "epidemias", "epidemiologia", "epidemico", "epidermis", "epifania", "epifanias", "epigrafe", "epigrafes", "epilepsia", "epileptico", "epilogo", "epilogos", "episcopal", "episodico", "episodicamente", "epistola", "epistolas", "epistolar", "epitaxial", "epitelio", "epitelial", "epitomar", "epitomado", "epitome", "epitomes", "eponimo", "eponimos", "epoptico", "epopticos", "epsilon", "epsilones", "epulide", "epulides", "epopeico", "epidemico", "epidermico", "epigastrico", "epigenetico", "epiglote", "epiglotico", "epigrafico", "epilatorio", "epileptiforme", "epilogal", "epilogistico", "epimorfosis", "epinefrina", "epipaleolitico", "epiploon", "epirrematico", "episcopado", "episiotomia", "epistemico", "epistilbite", "epistolarmente", "epitaxia", "epitaxico", "epitelial", "epitelioma", "epiteliomatoso", "epitematico", "epitermico", "epiteto", "epitimia", "epitimo", "epitomacion", "epitomador", "epitomista", "epitomizar", "epitopo", "epitroclea", "epitroclear", "epitropo", "epitropismo", "epixilo", "epizootia", "epizootico", "epo", "epos", "epodo", "epodos", "eponimo", "eponimia", "eponimico", "epopeico", "epoptia", "epoptas", "epopteia", "eporo", "epi", "epo"
    }
}

-- Hard Mode: categorias para escolha aleatória
local palavrasHardMode = {
    Y = {
        "angry", "away", "airy", "army", "ability", "activity", "anniversary", "allergy", "agency", "anatomy", "anxiety", "actually", "accuracy", "academy", "agility", "apology", "assembly", "antony", "anthony", "any", "ally", "already", "apply", "archaeology", "astronomy", "asymmetry", "audacity", "authority", "autonomy",
        "baby", "body", "busy", "berry", "bloody", "buddy", "bakery", "bravery", "biology", "balcony", "beauty", "bouncy", "brainy", "bushy", "bubbly", "buttery", "boundary", "bunny", "by", "buy", "boy", "bay", "battery", "betray", "biography", "botany", "burglary", "bury", "busybody",
        "city", "copy", "candy", "cloudy", "crazy", "comfy", "colony", "comedy", "century", "charity", "currency", "creamy", "chilly", "cheeky", "crispy", "cuddly", "cavity", "cry", "carry", "country", "company", "capacity", "celebrity", "chemistry", "clarity", "clumsy", "comply", "contrary", "controversy", "courtesy", "cowardly", "creativity", "cruelty", "curiosity", "customary", "cycle",
        "day", "dirty", "diary", "daddy", "daily", "dusty", "delivery", "deputy", "discovery", "destiny", "dignity", "dreamy", "dizzy", "drizzly", "daffy", "dandy", "dummmy", "dry", "decay", "delay", "democracy", "density", "diplomacy", "dishonesty", "display", "documentary", "donkey", "duality", "duty",
        "easy", "early", "empty", "entry", "enemy", "energy", "eternity", "embassy", "entity", "economy", "efficiency", "essay", "envy", "everybody", "especially", "emergency", "every", "ecology", "electricity", "employ", "equality", "estuary", "evidently", "exactly", "extraordinary",
        "funny", "fairy", "friendly", "family", "fancy", "foggy", "filthy", "frequency", "fantasy", "fidelity", "fury", "fluffy", "fishy", "frosty", "funky", "fully", "factory", "fly", "forty", "fifty", "finally", "flattery", "folly", "formality", "fraternity", "friendly", "fry",
        "gray", "guilty", "glory", "gummy", "giddy", "galaxy", "generosity", "grassy", "gay", "grocery", "gravity", "glitchy", "gooey", "gravy", "greedy", "groovy", "gallery", "geography", "geometry", "gladly", "gradually", "gratuity", "greedy", "gymnasty",
        "happy", "hungry", "hairy", "hobby", "heavy", "healthy", "honey", "hurry", "history", "harmony", "highway", "holy", "handy", "hasty", "hearty", "holyday", "honesty", "hospitality", "humanity", "humidity", "hungrily", "hybrid",
        "icy", "ivory", "inky", "identity", "injury", "irony", "inquiry", "industry", "infinity", "imagery", "itchy", "inventory", "immunity", "imply", "instantly", "integrity", "intensity", "irony", "ivory", "icky", "icily", "ideally", "illegally", "immensely",
        "jelly", "juicy", "jolly", "jerky", "jeopardy", "journey", "jellybean", "jaunty", "judiciary", "jewelry", "jumpy", "jokey", "jingly", "joy", "july", "january", "jealousy", "jockey", "joyfully", "jury",
        "kitty", "kindly", "knobby", "kidney", "key", "knavery", "knotty", "kittycat", "knowingly", "kooky", "kingly", "klutzy", "karate", "kennedy", "kidney", "kindly", "kitty", "knightly",
        "lazy", "lucky", "lovely", "lorry", "lively", "lonely", "liberty", "laundry", "luxury", "legacy", "locality", "leafy", "lengthy", "lousy", "loopy", "lumpy", "larry", "lady", "legally", "liability", "literally", "literary", "locality", "lonely", "lovely", "loyalty",
        "money", "messy", "mighty", "mommy", "memory", "melody", "mystery", "mercy", "monkey", "ministry", "murky", "moldy", "moody", "mushy", "minty", "mastery", "many", "marry", "may", "majority", "manually", "maturity", "mercy", "merely", "military", "minority", "modesty", "monarchy", "monthly", "morality", "mystery",
        "noisy", "navy", "naughty", "ninety", "nervy", "nobody", "necessity", "nursery", "nationality", "novelty", "natty", "nifty", "needy", "nutty", "nylony", "nasty", "nearly", "nicely", "normally", "notify", "novelty", "nursery",
        "only", "oily", "orderly", "occupancy", "ordinary", "obituary", "opportunity", "obesity", "originality", "okay", "oddly", "overly", "openly", "orangey", "obviously", "occasionally", "oddly", "officially", "opportunity", "oraly", "ordinary", "originally",
        "party", "puppy", "pretty", "plenty", "penny", "pantry", "philosophy", "poetry", "priority", "property", "perry", "parry", "puny", "poky", "puffy", "prickly", "pay", "play", "pray", "partially", "personality", "pharmacy", "photography", "physically", "pity", "policy", "poverty", "practically", "privacy", "probably", "property", "prosperity", "psychology", "publicly", "puppy", "purity",
        "quarry", "query", "queasy", "quality", "quantity", "quirky", "queenly", "quarterly", "quietly", "quivery", "quaky", "quality", "quantity", "quarterly", "quickly", "quietly",
        "rainy", "rosy", "rusty", "roomy", "remedy", "royalty", "reality", "rivalry", "recovery", "railway", "runny", "ray", "ready", "rocky", "rowdy", "rubbery", "rapidly", "rarely", "reality", "really", "recently", "relatively", "reliability", "remedy", "responsibility", "robbery", "royalty",
        "sunny", "sorry", "shiny", "silly", "sleepy", "stormy", "safety", "strategy", "sexy", "salary", "society", "slowly", "sandy", "smoky", "snowy", "sticky", "say", "sky", "spy", "sadly", "scary", "secretary", "security", "seventy", "severely", "shortly", "silently", "sincerely", "sixty", "slavery", "slippery", "socially", "solely", "solidarity", "specify", "spiritually", "stability", "steady", "sticky", "strictly", "suddenly", "supply", "surely", "surgery", "symphony",
        "tiny", "tasty", "twenty", "thirsty", "theory", "trophy", "tragedy", "tidy", "technology", "territory", "try", "testy", "touchy", "tricky", "twitchy", "temporally", "they", "today", "terribly", "testimony", "therapy", "thoroughly", "timely", "traditionally", "treasury", "truly", "typically", "tyranny",
        "ugly", "unity", "unwary", "unlucky", "uneasy", "unworthy", "utility", "university", "urgency", "uppity", "usually", "unanimously", "unexpectedly", "unfortunately", "unholy", "unity", "unlikely", "urgently", "usually", "utility",
        "very", "victory", "valley", "velocity", "vacancy", "vanity", "viceroy", "variety", "viability", "vinegary", "velvety", "validity", "vanity", "variety", "verify", "vibrantly", "victory", "visibility", "visually", "vitality", "voluntarily",
        "worry", "windy", "wealthy", "worthy", "weekly", "watery", "wavy", "wildly", "warranty", "worldly", "woody", "woolly", "wintry", "wiry", "way", "why", "warmly", "weakly", "weekly", "wholly", "widely", "willingly", "wisely", "wonderfully", "woody", "worldly", "worthy",
        "yummy", "yearly", "yeasty", "yellowy", "yucky", "youthfully", "yesterday", "yearly", "youthfully",
        "zany", "zingy", "zooey", "zesty", "zoomy", "zizzy", "zealotry", "zippy", "zoophyly", "zealously"
    },
    W = {
        "allow", "arrow", "below", "blow", "borrow", "bow", "brew", "brow", "chew", "claw", "cow", "crew", "dew", "draw", "drew", "elbow", "fallow", "few", "flow", "follow", "grew", "grow", "hallow", "how", "jaw", "knew", "know", "law", "low", "mallow", "marrow", "meow", "mew", "morrow", "narrow", "new", "now", "pillow", "plow", "rainbow", "raw", "renew", "row", "saw", "sew", "shadow", "show", "slaw", "slew", "slow", "snow", "sow", "sparrow", "spew", "stew", "straw", "swallow", "thaw", "thew", "throw", "tomorrow", "tow", "view", "vow", "wallow", "widow", "willow", "winnow", "yaw", "yew", "yellow"
    },
    LY = {
        "actually", "barely", "basically", "beautifully", "briefly", "carefully", "certainly", "clearly", "closely", "commonly", "completely", "constantly", "currently", "daily", "deeply", "definitely", "directly", "easily", "effectively", "entirely", "equally", "especially", "eventually", "exactly", "extremely", "fairly", "finally", "firmly", "formerly", "frequently", "fully", "generally", "gently", "gladly", "greatly", "hardly", "heavily", "highly", "honestly", "immediately", "increasingly", "initially", "jointly", "kindly", "largely", "lately", "likely", "literally", "lonely", "mainly", "merely", "mostly", "nearly", "necessarily", "newly", "normally", "obviously", "occasionally", "originally", "partially", "particularly", "perfectly", "personally", "physically", "poorly", "possibly", "precisely", "presently", "presumably", "previously", "primarily", "probably", "properly", "publicly", "quickly", "quietly", "rarely", "readily", "really", "recently", "relatively", "repeatedly", "reportedly", "roughly", "routinely", "sadly", "scarcely", "seemingly", "separately", "seriously", "severely", "shortly", "significantly", "similarly", "simply", "slightly", "slowly", "smoothly", "solely", "specifically", "steadily", "strictly", "strongly", "suddenly", "sufficiently", "supposedly", "surely", "tightly", "totally", "truly", "typically", "ultimately", "undoubtedly", "unfortunately", "unlikely", "usually", "virtually", "widely", "willingly"
    },
    XX = {
        "box", "fox", "fix", "mix", "six", "tax", "wax", "axe", "hex", "jinx", "lynx", "max", "next", "ox", "relax", "remix", "sex", "sixty", "text", "vex", "annex", "apex", "complex", "crux", "duplex", "flex", "flux", "helix", "hoax", "ibex", "index", "latex", "matrix", "onyx", "paradox", "phoenix", "prefix", "reflex", "sphinx", "suffix", "syntax", "thorax", "vertex", "vortex", "xerox"
    }
}

local hardModeCategorias = {"Y", "W", "LY", "XX"}

-- O restante do código continua igual a partir daqui...
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
mainFrame.Size = UDim2.new(0, 620, 0, 460)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
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
hardModeTitle.Text = "🟢 Hard Mode"
hardModeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
hardModeTitle.Font = Enum.Font.GothamBold
hardModeTitle.TextSize = 13
hardModeTitle.TextXAlignment = Enum.TextXAlignment.Left
hardModeTitle.ZIndex = 10
hardModeTitle.Parent = toggleFrame

local hardModeDesc = Instance.new("TextLabel")
hardModeDesc.Size = UDim2.new(1, -PADDING*2, 0, 32)
hardModeDesc.Position = UDim2.new(0, PADDING, 0, PADDING + 22)
hardModeDesc.BackgroundTransparency = 1
hardModeDesc.Text = "Random: Y, W, LY, X endings (or any word)"
hardModeDesc.TextColor3 = Color3.fromRGB(140, 140, 170)
hardModeDesc.Font = Enum.Font.Gotham
hardModeDesc.TextSize = 9
hardModeDesc.TextWrapped = true
hardModeDesc.TextXAlignment = Enum.TextXAlignment.Left
hardModeDesc.ZIndex = 10
hardModeDesc.Parent = toggleFrame

local hardToggleBtn = Instance.new("TextButton")
hardToggleBtn.Size = UDim2.new(1, -PADDING*2, 0, 36)
hardToggleBtn.Position = UDim2.new(0, PADDING, 0, PADDING + 58)
hardToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
hardToggleBtn.Text = "ENABLED"
hardToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
hardToggleBtn.Font = Enum.Font.GothamBold
hardToggleBtn.TextSize = 14
hardToggleBtn.ZIndex = 11
hardToggleBtn.Parent = toggleFrame
Instance.new("UICorner", hardToggleBtn).CornerRadius = UDim.new(0, 8)

local hardMode = true

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
safeModeTitle.Position = UDim2.new(0, PADDING, 0, PADDING + 110)
safeModeTitle.BackgroundTransparency = 1
safeModeTitle.Text = "🟢 Safe Mode"
safeModeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
safeModeTitle.Font = Enum.Font.GothamBold
safeModeTitle.TextSize = 13
safeModeTitle.TextXAlignment = Enum.TextXAlignment.Left
safeModeTitle.ZIndex = 10
safeModeTitle.Parent = toggleFrame

local safeModeDesc = Instance.new("TextLabel")
safeModeDesc.Size = UDim2.new(1, -PADDING*2, 0, 24)
safeModeDesc.Position = UDim2.new(0, PADDING, 0, PADDING + 132)
safeModeDesc.BackgroundTransparency = 1
safeModeDesc.Text = "Stops after 4 attempts, waits for you"
safeModeDesc.TextColor3 = Color3.fromRGB(140, 140, 170)
safeModeDesc.Font = Enum.Font.Gotham
safeModeDesc.TextSize = 9
safeModeDesc.TextWrapped = true
safeModeDesc.TextXAlignment = Enum.TextXAlignment.Left
safeModeDesc.ZIndex = 10
safeModeDesc.Parent = toggleFrame

local safeToggleBtn = Instance.new("TextButton")
safeToggleBtn.Size = UDim2.new(1, -PADDING*2, 0, 36)
safeToggleBtn.Position = UDim2.new(0, PADDING, 0, PADDING + 160)
safeToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
safeToggleBtn.Text = "ENABLED"
safeToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
safeToggleBtn.Font = Enum.Font.GothamBold
safeToggleBtn.TextSize = 14
safeToggleBtn.ZIndex = 11
safeToggleBtn.Parent = toggleFrame
Instance.new("UICorner", safeToggleBtn).CornerRadius = UDim.new(0, 8)

local safeMode = true

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
local detPalavras = createInfoRow(rightFrame, rightStartY + ROW_GAP*1, "Available", "0")
local detMesa     = createInfoRow(rightFrame, rightStartY + ROW_GAP*2, "Table",    "-")
local detPalavra  = createInfoRow(rightFrame, rightStartY + ROW_GAP*3, "Prefix",   "0")
local detUsadas   = createInfoRow(rightFrame, rightStartY + ROW_GAP*4, "Used",     "0")
local detErros    = createInfoRow(rightFrame, rightStartY + ROW_GAP*5, "Strikes",  "0")

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

local prefixosSemHardMode = {"X", "IC", "ER", "LY", "GY", "ANU", "PT", "DY", "CLE", "ED", "ION", "PY", "INE", "SY", "MENT", "SK", "CER", "SH", "Y", "AND", "AHA", "ANG", "OT", "ADO", "IS", "MYR", "OST", "YU", "NY", "OX", "PS", "OS", "HYD", "INGL", "LYC", "ESV", "EP"}

local function encontrarPalavras(prefixo, tentadas)
    local candidatas = {}
    local primeiraLetra = prefixo:sub(1, 1):upper()
    local duasLetras = prefixo:sub(1, 2):upper()
    local tresLetras = prefixo:sub(1, 3):upper()
    local quatroLetras = prefixo:sub(1, 4):upper()
    
    local usarHardMode = hardMode
    if hardMode then
        for _, exc in ipairs(prefixosSemHardMode) do
            local len = #exc
            if prefixo:sub(1, len) == exc then
                usarHardMode = false
                break
            end
        end
    end
    
    if usarHardMode then
        local categoriasEmbaralhadas = {}
        for _, cat in ipairs(hardModeCategorias) do
            table.insert(categoriasEmbaralhadas, cat)
        end
        for i = #categoriasEmbaralhadas, 2, -1 do
            local j = math.random(i)
            categoriasEmbaralhadas[i], categoriasEmbaralhadas[j] = categoriasEmbaralhadas[j], categoriasEmbaralhadas[i]
        end
        
        for _, categoria in ipairs(categoriasEmbaralhadas) do
            local listaPalavras = palavrasHardMode[categoria]
            if listaPalavras then
                for _, p in pairs(listaPalavras) do
                    local pu = p:upper()
                    if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                        table.insert(candidatas, p)
                    end
                end
            end
        end
    end
    
    if #candidatas == 0 then
        if palavrasPorPrefixo[quatroLetras] then
            for _, p in pairs(palavrasPorPrefixo[quatroLetras]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
        
        if #candidatas == 0 and palavrasPorPrefixo[tresLetras] then
            for _, p in pairs(palavrasPorPrefixo[tresLetras]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
        
        if #candidatas == 0 and palavrasPorPrefixo[duasLetras] then
            for _, p in pairs(palavrasPorPrefixo[duasLetras]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
                end
            end
        end
        
        if #candidatas == 0 and palavrasPorPrefixo[primeiraLetra] then
            for _, p in pairs(palavrasPorPrefixo[primeiraLetra]) do
                local pu = p:upper()
                if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                    table.insert(candidatas, p)
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
    end
    
    local unicas = {}
    local seen = {}
    for _, p in pairs(candidatas) do
        local pu = p:upper()
        if not seen[pu] and not tentadas[pu] then
            seen[pu] = true
            table.insert(unicas, p)
        end
    end
    
    return unicas
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

local function getStrikesErradas()
    local erros = 0
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end
    
    local screen = playerGui:FindFirstChild("ScreenGui") or playerGui:FindFirstChild("screenGui") or playerGui:FindFirstChild("Screen Gui")
    if not screen then
        for _, child in pairs(playerGui:GetChildren()) do
            if child:IsA("ScreenGui") and (child:FindFirstChild("BottomBar") or child:FindFirstChild("CenterBar")) then
                screen = child
                break
            end
        end
    end
    
    if not screen then return 0 end
    
    local bottomBar = screen:FindFirstChild("BottomBar")
    if not bottomBar then return 0 end
    
    local centerBar = bottomBar:FindFirstChild("CenterBar")
    if not centerBar then return 0 end
    
    local strikes = centerBar:FindFirstChild("Strikes")
    if not strikes then return 0 end
    
    for i = 1, 5 do
        local strike = strikes:FindFirstChild(tostring(i))
        if strike and strike:IsA("ImageLabel") then
            local textLabel = strike:FindFirstChildWhichIsA("TextLabel")
            if textLabel then
                local color = textLabel.TextColor3
                if math.abs(color.R * 255 - 230) <= 10 and math.abs(color.G * 255 - 76) <= 10 and math.abs(color.B * 255 - 96) <= 10 then
                    erros = erros + 1
                end
            end
        end
    end
    
    return erros
end

local function apagarLetras(qtd)
    if qtd <= 0 then return end
    for i = 1, qtd do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, nil)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, nil)
        task.wait(0.03)
    end
    task.wait(0.1)
end

local function digitarResto(palavra, base)
    local resto = palavra:sub(#base + 1)
    if resto == "" then
        task.wait(0.25)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
        task.wait(0.10)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
        return 0
    end
    for letra in resto:gmatch(".") do
        local keyCode = Enum.KeyCode[letra:upper()]
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
            task.wait(0.10 + math.random() * 0.06)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
            task.wait(0.08 + math.random() * 0.05)
        end
    end
    task.wait(0.25)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
    task.wait(0.10)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
    return #resto
end

local verificando = false
local tempoEnvio = 0
local tentativas = 0
local MAX_TENTATIVAS = 5
local TEMPO_VERIFICACAO = 1.2
local TEMPO_TOTAL = 14
local inicioRodada = 0
local ultimaBase = ""
local qtdLetrasDigitadas = 0
local temHydra = false
local errosAnteriores = 0
local semPalavras = false
local escolhaJaFeita = false
local ultimoTempoChoice = 0
local TEMPO_ENTRE_CHOICES = 2.0

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
    
    local usadasCount = 0
    for _ in pairs(palavrasTentadas) do
        usadasCount = usadasCount + 1
    end
    detUsadas.Text = tostring(usadasCount)
    detErros.Text = tostring(getStrikesErradas())
end

local function tentarPalavra(baseAgora, tempoRestante)
    local candidatas = encontrarPalavras(baseAgora, palavrasTentadas)
    
    if #candidatas > 0 then
        semPalavras = false
        local palavra = candidatas[math.random(1, #candidatas)]
        palavrasTentadas[palavra:upper()] = true
        
        atualizarInterface("Trying: " .. palavra:upper() .. " (" .. string.format("%.1f", tempoRestante) .. "s)", idioma, #candidatas, detMesa.Text, baseAgora)
        
        qtdLetrasDigitadas = digitarResto(palavra, baseAgora)
        tempoEnvio = os.clock()
        return true
    else
        if not semPalavras then
            semPalavras = true
            atualizarInterface("No words left! Skipping...", idioma, 0, detMesa.Text, baseAgora)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
            task.wait(0.08)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
            qtdLetrasDigitadas = 0
            tempoEnvio = os.clock()
        end
        return false
    end
end

spawn(function()
    while scriptAtivo do
        if botAtivo then
            local agora = os.clock()
            if agora - ultimoTempoChoice > 1.5 then
                ultimoTempoChoice = agora
                
                local fezEscolha = false
                pcall(function()
                    fezEscolha = autoEscolherLetra()
                end)
                
                if fezEscolha then
                    print("[Vortex] ChoiceList: Letra escolhida automaticamente!")
                    escolhaJaFeita = true
                    task.wait(0.5)
                end
            end
        end
        task.wait(0.3)
    end
end)

while scriptAtivo do
    local inGame, isTurn = getPlayerAttributes()
    
    if not botAtivo then
        atualizarInterface("PAUSED - Click ON to resume", idioma, 0, "-", "0")
        verificando = false
        tentativas = 0
        escolhaJaFeita = false
        task.wait(0.3)
        continue
    end
    
    if not inGame then
        atualizarInterface("Not in game", idioma, 0, "-", "0")
        verificando = false
        tentativas = 0
        palavrasTentadas = {}
        semPalavras = false
        errosAnteriores = 0
        ultimaBase = ""
        escolhaJaFeita = false
        task.wait(0.3)
        continue
    end
    
    if not escolhaJaFeita then
        local fezEscolha = false
        pcall(function()
            fezEscolha = autoEscolherLetra()
        end)
        if fezEscolha then
            print("[Vortex] ChoiceList: Letra escolhida (loop principal)!")
            escolhaJaFeita = true
            task.wait(0.5)
        end
    end
    
    local matchDisplay, mesaNumero = findMyTable(inGame)
    
    if matchDisplay then
        temHydra = temPetHydraNaMesa(inGame)
        local prefixo = getPrefixo(matchDisplay)
        local palavraPet = getPalavraDoPet(matchDisplay, temHydra)
        
        local baseAgora = ""
        
        if palavraPet ~= "" then
            baseAgora = palavraPet
            TEMPO_VERIFICACAO = 1.5
        elseif prefixo then
            baseAgora = prefixo
            TEMPO_VERIFICACAO = 1.2
        end
        
        local palavrasCount = 0
        if baseAgora ~= "" then
            local candidatasTemp = encontrarPalavras(baseAgora, palavrasTentadas)
            palavrasCount = #candidatasTemp
        end
        
        if baseAgora ~= "" then
            if baseAgora ~= ultimaBase then
                ultimaBase = baseAgora
                tentativas = 0
                verificando = false
                semPalavras = false
                errosAnteriores = getStrikesErradas()
                inicioRodada = os.clock()
                escolhaJaFeita = false
            end
            
            local tempoRestante = TEMPO_TOTAL - (os.clock() - inicioRodada)
            if tempoRestante < 0 then tempoRestante = 0 end
            
            local errosAtuais = getStrikesErradas()
            
            if errosAtuais > errosAnteriores then
                errosAnteriores = errosAtuais
                if verificando then
                    apagarLetras(qtdLetrasDigitadas)
                    tentativas = tentativas + 1
                    
                    if safeMode and errosAtuais >= 4 then
                        atualizarInterface("SAFE MODE: 4 errors! Waiting...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                        verificando = false
                    elseif tentativas > MAX_TENTATIVAS or tempoRestante <= 0 or semPalavras then
                        atualizarInterface("Max attempts!", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                        verificando = false
                    else
                        tentarPalavra(baseAgora, tempoRestante)
                        verificando = true
                    end
                end
            end
            
            if safeMode and errosAtuais >= 4 then
                atualizarInterface("SAFE MODE: 4 errors! Waiting...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                verificando = false
                task.wait(0.3)
                continue
            end
            
            MAX_TENTATIVAS = safeMode and (4 - errosAtuais) or 5
            if MAX_TENTATIVAS <= 0 then MAX_TENTATIVAS = 1 end
            
            if isTurn or verificando then
                
                if verificando then
                    local tempoPassado = os.clock() - tempoEnvio
                    
                    if tempoPassado > TEMPO_VERIFICACAO then
                        local _, aindaTurno = getPlayerAttributes()
                        
                        if aindaTurno and not semPalavras then
                            apagarLetras(qtdLetrasDigitadas)
                            tentativas = tentativas + 1
                            
                            errosAtuais = getStrikesErradas()
                            errosAnteriores = errosAtuais
                            
                            if safeMode and errosAtuais >= 4 then
                                atualizarInterface("SAFE MODE: 4 errors! Waiting...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                                verificando = false
                            elseif tentativas > MAX_TENTATIVAS or tempoRestante <= 0 or semPalavras then
                                atualizarInterface("Max attempts!", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                                verificando = false
                            else
                                tentarPalavra(baseAgora, tempoRestante)
                                verificando = true
                            end
                        elseif aindaTurno and semPalavras then
                            verificando = false
                        else
                            atualizarInterface("Accepted! ✓", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                            verificando = false
                            tentativas = 0
                            semPalavras = false
                            errosAnteriores = getStrikesErradas()
                        end
                    end
                else
                    tentativas = 1
                    inicioRodada = os.clock()
                    semPalavras = false
                    errosAnteriores = getStrikesErradas()
                    
                    atualizarInterface("Thinking...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                    local delayInicial = 0.8 + math.random() * 1.2
                    task.wait(delayInicial)
                    
                    if tentarPalavra(baseAgora, TEMPO_TOTAL) then
                        verificando = true
                    else
                        verificando = true
                    end
                end
            else
                atualizarInterface("Waiting for your turn...", idioma, palavrasCount, mesaNumero or "-", baseAgora)
                verificando = false
                tentativas = 0
                semPalavras = false
                errosAnteriores = getStrikesErradas()
            end
        else
            atualizarInterface("Waiting for letters...", idioma, 0, mesaNumero or "-", "0")
            verificando = false
        end
    else
        atualizarInterface("Searching table " .. tostring(inGame) .. "...", idioma, 0, "-", "0")
        verificando = false
    end
    
    task.wait(0.15)
end