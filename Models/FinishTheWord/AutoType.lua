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
local TweenService = game:GetService("TweenService")

local function autoEscolherLetra()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then 
        return false 
    end
    
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
    
    if not choiceList.Visible then 
        return false 
    end
    
    local opcoes = {}
    
    for _, child in pairs(choiceList:GetChildren()) do
        if child:IsA("ImageButton") or child:IsA("ImageLabel") or child:IsA("TextButton") then
            if child.Visible then
                table.insert(opcoes, child)
            end
        end
    end
    
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
    
    local escolhida = unicas[math.random(1, #unicas)]
    
    local sucesso = false
    pcall(function()
        local absPos = escolhida.AbsolutePosition
        local absSize = escolhida.AbsoluteSize
        local clickX = absPos.X + absSize.X / 2
        local clickY = absPos.Y + absSize.Y / 2
        
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
        task.wait(0.03)
        
        sucesso = true
    end)
    
    return sucesso
end

local palavrasPT = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Ao", "Ar", "As", "At", "Ah", "Ai", "Al", "Am", "An",
        "Da", "De", "Di", "Do", "Du", "Em", "Eu", "Ex", "Eh", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Fim", "Ha", "He", "Hi", "Ho", "Hu",
        "Ia", "Io", "Ir", "Is", "It", "Iu",
        "Ja", "Je", "Ji", "Jo", "Ju",
        "Ka", "Ke", "Ki", "Ko", "Ku", "La", "Le", "Li", "Lo", "Lu", "Lua", "Ly",
        "Ma", "Me", "Mi", "Mo", "Mu", "Mar", "Mao", "Mel", "Mau",
        "Na", "Ne", "Ni", "No", "Nu", "Nao", "Nos", "Ny",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Paz", "Pau", "Pe",
        "Ra", "Re", "Ri", "Ro", "Ru", "Rua", "Rio", "Ria",
        "Sa", "Se", "Si", "So", "Su", "Sol", "Sim", "Sou", "Sal",
        "Ta", "Te", "Ti", "To", "Tu", "Tal", "Tao",
        "Ua", "Ui", "Um", "Uns", "Uma", "Umas", "Ur",
        "Va", "Ve", "Vi", "Vo", "Vu", "Vai", "Vem", "Viu", "Vos",
        "Xa", "Xe", "Xi", "Xo", "Xu", "Xis",
        "Yu", "Yun", "Yur",
        "Za", "Ze", "Zi", "Zo", "Zu",
        "Ic", "Ica", "Ice", "Ico", "Icu",
        "Um", "Uma", "Ume", "Umi", "Umo",
        "Sac", "Saca", "Sace", "Saci", "Saco", "Sacu",
        "Cos", "Cosa", "Cose", "Cosi", "Coso", "Cosu",
        "Of", "Ofa", "Ofe", "Ofi", "Ofo", "Ofu",
        "Alp", "Alpa", "Alpe", "Alpi", "Alpo", "Alpu",
        "Esv", "Esva", "Esve", "Esvi", "Esvo", "Esvu",
        "Eo", "Eol", "Eon", "Eos", "Eou"
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
        "Xadrez", "Xarope", "Xerife", "Xerox", "Xicara", "Xingo", "Xixi", "Xodo", "Xucro", "Xenon", "Xereta", "Xampu", "Xale", "Xara", "Xavante", "Xisto",
        "Zebra", "Zero", "Zangado", "Ziper", "Zona", "Zoo", "Zumbi",
        
        -- Palavras com "EO"
        "Eolicas", "Eolico", "Eolicos", "Eolica", "Eolismo", "Eolismos",
        "Eon", "Eons", "Eonico", "Eonicos", "Eonica", "Eonicas",
        "Eosina", "Eosinas", "Eosinofilo", "Eosinofilos",
        "Eosinopenia", "Eosinopenias", "Eosinofilia", "Eosinofilias",
        "Eouve", "Eouves", "Eouvem", "Eouvir",
        
        "Icaro", "Icara", "Icarai", "Iceberg", "Icebergs", "Ichthyologia", "Ichthyologico", "Ichthyologo",
        "Iciclo", "Iciclos", "Icneumon", "Icneumons", "Icneumonideo", "Icneumonideos",
        "Icnita", "Icnitas", "Icnofossil", "Icnofosseis", "Icnologia", "Icnologico",
        "Icone", "Icones", "Iconico", "Iconicos", "Iconica", "Iconicas",
        "Iconoclasta", "Iconoclastas", "Iconoclastia", "Iconoclastico",
        "Iconografia", "Iconografico", "Iconografica", "Iconografias",
        "Iconolatra", "Iconolatras", "Iconolatria", "Iconolatrico",
        "Iconologia", "Iconologico", "Iconologica", "Iconologias",
        "Iconoscopio", "Iconoscopios", "Iconostase", "Iconostases",
        "Icor", "Icores", "Icosaedro", "Icosaedros", "Icosaedrico", "Icosaedricos",
        "Ictericia", "Ictericias", "Icterico", "Ictericos", "Icterica", "Ictericas",
        "Ictiocola", "Ictiofagia", "Ictiofago", "Ictiofagos",
        "Ictiografia", "Ictiografico", "Ictiologo", "Ictiologos",
        "Ictiologia", "Ictiologico", "Ictiologica", "Ictiose", "Ictioses",
        "Ictiossauro", "Ictiossauros", "Ictus",
        
        "Um", "Uma", "Umas", "Uns",
        "Umbanda", "Umbandas", "Umbela", "Umbelas", "Umbelado", "Umbelados",
        "Umbigo", "Umbigos", "Umbilicado", "Umbilicados", "Umbilical", "Umbilicais",
        "Umbla", "Umblas", "Umbral", "Umbrais",
        "Umbria", "Umbrias", "Umbro", "Umbros", "Umbroso", "Umbrosa", "Umbrosos", "Umbrosas",
        "Umedecer", "Umedecido", "Umedecida", "Umedecidos", "Umedecidas",
        "Umidade", "Umidades", "Umido", "Umidos", "Umida", "Umidas",
        "Umidificar", "Umidificado", "Umidificada",
        
        "Saca", "Sacas", "Sacada", "Sacadas", "Sacado", "Sacados",
        "Sacabuxa", "Sacabuxas", "Sacacorcho", "Sacacorchos",
        "Sacadela", "Sacadelas", "Sacadinha", "Sacadinhas",
        "Sacana", "Sacanas", "Sacanagem", "Sacanagens",
        "Sacanear", "Sacaneado", "Sacaneada", "Sacaneados", "Sacaneadas",
        "Sacao", "Sacoes", "Sacerdocio", "Sacerdocios",
        "Sacerdotal", "Sacerdotais", "Sacerdotalismo", "Sacerdotalismos",
        "Sacerdote", "Sacerdotes", "Sacerdotisa", "Sacerdotisas",
        "Sachola", "Sacholas", "Saci", "Sacia", "Sacias", "Saciado", "Saciados",
        "Saciar", "Saciante", "Saciantes", "Saciavel", "Saciaveis",
        "Sacola", "Sacolas", "Sacolada", "Sacoladas", "Sacolejar", "Sacolejado",
        "Sacolejo", "Sacolejos", "Saco", "Sacos",
        "Sacolao", "Sacoloes", "Sacudida", "Sacudidas",
        "Sacudir", "Sacudido", "Sacudidos", "Sacudida", "Sacudidas",
        "Sacramento", "Sacramentos", "Sacramental", "Sacramentais",
        "Sacral", "Sacrais", "Sacralidade", "Sacralidades",
        "Sacralizar", "Sacralizado", "Sacralizada", "Sacralizacao",
        "Sacrario", "Sacrarios", "Sacrificar", "Sacrificado",
        "Sacrificio", "Sacrificios", "Sacrificante", "Sacrificantes",
        "Sacrilegio", "Sacrilegios", "Sacrilego", "Sacrilegos", "Sacrilega", "Sacrilegas",
        "Sacro", "Sacros", "Sacra", "Sacras", "Sacrossanto", "Sacrossantos",
        
        "Cosa", "Cosas", "Cosaco", "Cosacos", "Cosaca", "Cosacas",
        "Cose", "Coses", "Cosedura", "Coseduras", "Cosecha", "Cosechas",
        "Coselho", "Coselhos", "Coser", "Cosido", "Cosidos", "Cosida", "Cosidas",
        "Cosmetico", "Cosmeticos", "Cosmetica", "Cosmeticas",
        "Cosmetologia", "Cosmetologico", "Cosmetologista",
        "Cosmico", "Cosmicos", "Cosmica", "Cosmicas",
        "Cosmismo", "Cosmismos", "Cosmista", "Cosmistas",
        "Cosmo", "Cosmos", "Cosmocracia", "Cosmocracias",
        "Cosmodromo", "Cosmodromos", "Cosmogenia", "Cosmogenias",
        "Cosmogonia", "Cosmogonias", "Cosmogonico", "Cosmogonicos",
        "Cosmografia", "Cosmografias", "Cosmografico", "Cosmograficos",
        "Cosmologo", "Cosmologos", "Cosmologa", "Cosmologas",
        "Cosmologia", "Cosmologias", "Cosmologico", "Cosmologicos",
        "Cosmonauta", "Cosmonautas", "Cosmonautica", "Cosmonauticas",
        "Cosmopolita", "Cosmopolitas", "Cosmopolitismo", "Cosmopolitismos",
        "Cosmorama", "Cosmoramas", "Cosmovisao", "Cosmovisoes",
        "Coso", "Cosos", "Cossa", "Cossas", "Cosso", "Cossos",
        "Cossaco", "Cossacos", "Cossaca", "Cossacas",
        "Cosseno", "Cossenos", "Cossoide", "Cossoides",
        "Costa", "Costas", "Costado", "Costados", "Costeira", "Costeiras",
        "Costal", "Costais", "Costela", "Costelas", "Costeleta", "Costeletas",
        "Costumar", "Costumado", "Costume", "Costumes",
        "Costura", "Costuras", "Costurar", "Costurado", "Costurada",
        "Costureira", "Costureiras", "Costureiro", "Costureiros",
        
        "Ofegante", "Ofegantes", "Ofegar", "Ofegado", "Ofegada",
        "Ofego", "Ofegos", "Ofegueira", "Ofegueiras",
        "Ofensor", "Ofensores", "Ofensora", "Ofensoras",
        "Ofensa", "Ofensas", "Ofensivo", "Ofensivos", "Ofensiva", "Ofensivas",
        "Ofendido", "Ofendidos", "Ofendida", "Ofendidas",
        "Ofender", "Ofende", "Ofendem",
        "Ofertar", "Ofertado", "Ofertada", "Oferta", "Ofertas",
        "Oferenda", "Oferendas", "Ofertante", "Ofertantes",
        "Ofertorio", "Ofertorios", "Ofertar",
        "Ofiaco", "Ofiacos", "Ofiase", "Ofiases",
        "Ofidiario", "Ofidiarios", "Ofidico", "Ofidicos", "Ofidica", "Ofidicas",
        "Ofidio", "Ofidios", "Ofidiofobia", "Ofidiofobias",
        "Ofidiologo", "Ofidiologos", "Ofidiologia", "Ofidiologias",
        "Ofidismo", "Ofidismos", "Ofidiotoxina", "Ofidiotoxinas",
        "Ofiolatra", "Ofiolatras", "Ofiolatria", "Ofiolatrias",
        "Ofiologia", "Ofiologias", "Ofiologico", "Ofiologicos",
        "Ofiomancia", "Ofiomancias", "Ofiomante", "Ofiomantes",
        "Ofion", "Ofions", "Ofionimo", "Ofionimos",
        "Ofita", "Ofitas", "Ofitico", "Ofiticos",
        "Ofito", "Ofitos", "Ofiucomorfo", "Ofiucomorfos",
        "Ofiuco", "Ofiucos", "Ofiuculo", "Ofiuculos",
        "Ofuscante", "Ofuscantes", "Ofuscar", "Ofuscado", "Ofuscada",
        "Ofuscacao", "Ofuscacoes", "Ofuscador", "Ofuscadores",
        "Oftalmia", "Oftalmias", "Oftalmica", "Oftalmicas",
        "Oftalmico", "Oftalmicos", "Oftalmitis",
        "Oftalmo", "Oftalmos", "Oftalmologia", "Oftalmologias",
        "Oftalmologista", "Oftalmologistas", "Oftalmologico",
        "Oftalmoplegia", "Oftalmoplegias", "Oftalmorreia", "Oftalmorreias",
        "Oftalmoscopio", "Oftalmoscopios", "Oftalmotomia", "Oftalmotomias",
        
        "Alpaca", "Alpacas", "Alpaco", "Alpacos",
        "Alparca", "Alparcas", "Alpargata", "Alpargatas",
        "Alpargataria", "Alpargatarias", "Alpargateiro", "Alpargateiros",
        "Alpaxa", "Alpaxas", "Alpaz", "Alpazes",
        "Alpe", "Alpes", "Alpestre", "Alpestres",
        "Alpi", "Alpis", "Alpico", "Alpicos",
        "Alpinia", "Alpinias", "Alpinismo", "Alpinismos",
        "Alpinista", "Alpinistas", "Alpinistico", "Alpinisticos",
        "Alpino", "Alpinos", "Alpina", "Alpinas",
        "Alpo", "Alpos", "Alpoim", "Alpoins",
        "Alpude", "Alpudes", "Alpujarra", "Alpujarras",
        "Alpurgar", "Alpurgado", "Alpurgada",
        "Alqueire", "Alqueires", "Alqueireiro", "Alqueireiros",
        "Alquimia", "Alquimias", "Alquimico", "Alquimicos",
        "Alquimista", "Alquimistas", "Alquimizar", "Alquimizado",
        "Alquitar", "Alquitado", "Alquitara", "Alquitaras",
        "Alcor", "Alcores", "Alcorano", "Alcoranos",
        "Alcoranico", "Alcoranicos", "Alcoranista", "Alcoranistas",
        "Alcova", "Alcovas", "Alcoviteiro", "Alcoviteiros",
        "Alcovitice", "Alcovitices", "Alcovitar", "Alcovitado",
        "Alcunha", "Alcunhas", "Alcunhar", "Alcunhado",
        "Alcunhador", "Alcunhadores", "Alcunhante", "Alcunhantes",
        "Aldeia", "Aldeias", "Aldeao", "Aldeoes", "Aldea", "Aldeas",
        "Aldeamento", "Aldeamentos", "Aldear", "Aldeado",
        
        "Esvair", "Esvai", "Esvaiu", "Esvaindo", "Esvairam",
        "Esvaido", "Esvaidos", "Esvaida", "Esvaidas",
        "Esvaziar", "Esvaziado", "Esvaziada", "Esvaziados", "Esvaziadas",
        "Esvaziamento", "Esvaziamentos", "Esvaziante", "Esvaziantes",
        "Esvaziador", "Esvaziadores", "Esvaziadora", "Esvaziadoras",
        "Esvaziavel", "Esvaziaveis",
        "Esverdear", "Esverdeado", "Esverdeada", "Esverdeados", "Esverdeadas",
        "Esverdeamento", "Esverdeamentos", "Esverdeante", "Esverdeantes",
        "Esverdinho", "Esverdinhos", "Esverdinha", "Esverdinhas",
        "Esverdinhado", "Esverdinhados", "Esverdinhada", "Esverdinhadas",
        "Esvoacar", "Esvoacado", "Esvoacada", "Esvoacados", "Esvoacadas",
        "Esvoacante", "Esvoacantes", "Esvoacador", "Esvoacadores",
        "Esvoacamento", "Esvoacamentos", "Esvoacavel", "Esvoacaveis",
        "Esvanecer", "Esvanecido", "Esvanecida", "Esvanecidos", "Esvanecidas",
        "Esvanecimento", "Esvanecimentos", "Esvanescente", "Esvanescentes",
        "Esvanescencia", "Esvanescencias", "Esvanecivel", "Esvaneciveis",
        "Esvanear", "Esvaneado", "Esvaneada", "Esvaneados", "Esvaneadas",
        "Esvaporar", "Esvaporado", "Esvaporada", "Esvaporados", "Esvaporadas",
        "Esvaporacao", "Esvaporacoes", "Esvaporante", "Esvaporantes",
        "Esvaporavel", "Esvaporaveis", "Esvaporizar", "Esvaporizado",
        "Esvasiado", "Esvasiados", "Esvasiada", "Esvasiadas",
        "Esvazio", "Esvazios", "Esvazia", "Esvazias",
    }
}

local palavrasEN = {
    ["CURTAS"] = {
        "A", "I", "O", "Y", "Am", "An", "As", "At", "Ah", "Ai", "Al", "Ar", "Ax",
        "Be", "By", "Bo", "Bi", "Co", "Ca", "Ce", "Ci", "Cu",
        "Do", "Da", "De", "Di", "Du", "Em", "El", "Es", "Ex", "Er",
        "Fa", "Fe", "Fi", "Fo", "Fu", "Go", "Ga", "Ge", "Gi", "Gu",
        "Ha", "He", "Hi", "Ho", "Hu",
        "If", "In", "Is", "It",
        "La", "Le", "Li", "Lo", "Lu", "Ly",
        "Ma", "Me", "Mi", "Mo", "Mu", "My",
        "Na", "Ne", "Ni", "No", "Nu", "Ny", "Of", "Oh", "Oi", "Ok", "On", "Or", "Os", "Ow", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Sh", "Si", "So", "St", "Su", "Ta", "Te", "Th", "Ti", "To", "Tu",
        "Um", "Un", "Up", "Us", "Va", "Ve", "Vi", "Vo", "Vu",
        "Wa", "We", "Wi", "Wo", "Wu", "Xe", "Xi", "Xu", "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu",
        "Ic", "Ice", "Ich", "Ico",
        "Um", "Umb", "Ump",
        "Sac", "Sack", "Saco",
        "Cos", "Cosh", "Cosm",
        "Of", "Off", "Oft",
        "Alp", "Alps", "Alph",
        "Esv",
        "Eo", "Eon", "Eos", "Eoh"
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
        "Ice", "Icy", "Icon", "Idea", "Idle", "Idol", "Inch", "Into", "Iron", "Isle", "Issue", "Item", "Itch",
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
        "Zap", "Zen", "Zig", "Zip", "Zoo",
        
        -- EO Words
        "Eolithic", "Eon", "Eons", "Eonian", "Eonism", "Eonisms",
        "Eosin", "Eosinophil", "Eosinophils", "Eosinophilia",
        "Eosinophilic", "Eohippus", "Eohippuses",
        
        "Icarus", "Ice", "Iceberg", "Icebergs", "Icebound", "Icebox", "Iceboxes",
        "Icebreaker", "Icebreakers", "Icecap", "Icecaps", "Icecream", "Icecreams",
        "Iced", "Icefall", "Icefalls", "Icefield", "Icefields",
        "Icehouse", "Icehouses", "Icelander", "Icelanders",
        "Iceland", "Icelandic", "Iceless", "Icemaker", "Icemakers",
        "Iceman", "Icemen", "Ices", "Iceskate", "Iceskates",
        "Ich", "Ichnite", "Ichnites", "Ichnofossil", "Ichnofossils",
        "Ichnology", "Ichnologic", "Ichnological",
        "Ichor", "Ichors", "Ichorous",
        "Ichneumon", "Ichneumons", "Ichneumonid", "Ichneumonids",
        "Ichthyology", "Ichthyologist", "Ichthyosaur", "Ichthyosaurs",
        "Ichthyosis", "Ichthyotic", "Icicle", "Icicles", "Icicled",
        "Icily", "Iciness", "Icing", "Icings",
        "Icon", "Icons", "Iconic", "Iconical", "Iconically",
        "Iconoclasm", "Iconoclast", "Iconoclasts",
        "Iconoclastic", "Iconographic", "Iconographical",
        "Iconography", "Iconolater", "Iconolaters",
        "Iconolatry", "Iconologic", "Iconological",
        "Iconology", "Iconophile", "Iconophiles",
        "Iconoscope", "Iconoscopes", "Iconostasis", "Iconostases",
        "Icosahedral", "Icosahedron", "Icosahedrons", "Icosahedra",
        "Icterical", "Icterine", "Icteroid", "Icterus",
        "Ictic", "Ictus", "Ictuses", "Icy", "Icier", "Iciest",
        
        "Umb", "Umbel", "Umbels", "Umbeled", "Umbellate", "Umbellated",
        "Umbellifer", "Umbellifers", "Umbelliferous",
        "Umber", "Umbers", "Umbilic", "Umbilical", "Umbilically",
        "Umbilicate", "Umbilicated", "Umbilication", "Umbilications",
        "Umbilicus", "Umbilici", "Umbilicuses",
        "Umbo", "Umbones", "Umbos", "Umbonal", "Umbonate",
        "Umbra", "Umbras", "Umbrae", "Umbrage", "Umbrages",
        "Umbrageous", "Umbrageously", "Umbrageousness",
        "Umbral", "Umbratic", "Umbratile",
        "Umbrella", "Umbrellas", "Umbrellaless",
        "Umbriferous", "Umbrine", "Umbrous",
        "Umi", "Umiak", "Umiaks",
        "Umlaut", "Umlauts", "Umlauted",
        "Umm", "Ummah", "Ummahs",
        "Ump", "Umps", "Umpirage", "Umpirages",
        "Umpire", "Umpires", "Umpired", "Umpiring",
        "Umpteen", "Umpteenth", "Umteenth",
        
        "Sac", "Sacs", "Saccade", "Saccades", "Saccadic",
        "Saccate", "Sacchate", "Sacchates",
        "Sacchar", "Sacchars", "Saccharic",
        "Saccharide", "Saccharides", "Sacchariferous",
        "Saccharify", "Saccharified", "Saccharifying",
        "Saccharimeter", "Saccharimeters",
        "Saccharin", "Saccharins", "Saccharine",
        "Saccharize", "Saccharized",
        "Saccharoid", "Saccharoidal",
        "Saccharose", "Saccharoses",
        "Sacciform", "Sacculus",
        "Saccule", "Saccules", "Sacculi", "Saccular",
        "Sacculate", "Sacculated", "Sacculation",
        "Sacker", "Sackers", "Sacking", "Sackings",
        "Sackbut", "Sackbuts", "Sackcloth", "Sackcloths",
        "Sacrament", "Sacraments", "Sacramental", "Sacramentals",
        "Sacraria", "Sacrarium", "Sacraria",
        "Sacred", "Sacredly", "Sacredness",
        "Sacrifice", "Sacrifices", "Sacrificed",
        "Sacrificial", "Sacrificially",
        "Sacrilege", "Sacrileges", "Sacrilegious",
        "Sacrilegiously", "Sacrilegiousness",
        "Sacring", "Sacrings", "Sacrist", "Sacrists",
        "Sacristan", "Sacristans", "Sacristy",
        "Sacro", "Sacrococcygeal",
        "Sacrosanct", "Sacrosanctity",
        "Sacrum", "Sacrums", "Sacra",
        
        "Cos", "Cosec", "Cosecant", "Cosecants",
        "Coseismal", "Coseismic",
        "Cosh", "Cosher", "Coshing",
        "Cosign", "Cosigned", "Cosigner", "Cosigners",
        "Cosine", "Cosines", "Cosiness",
        "Cosmetic", "Cosmetics", "Cosmetically",
        "Cosmetician", "Cosmeticians",
        "Cosmetologist", "Cosmetologists", "Cosmetology",
        "Cosmic", "Cosmical", "Cosmically",
        "Cosmism", "Cosmisms", "Cosmist", "Cosmists",
        "Cosmo", "Cosmochemistry",
        "Cosmocrat", "Cosmocrats", "Cosmocratic",
        "Cosmodrome", "Cosmodromes",
        "Cosmogenesis", "Cosmogenetic", "Cosmogenic",
        "Cosmogonic", "Cosmogonical",
        "Cosmogonist", "Cosmogonists", "Cosmogony",
        "Cosmographer", "Cosmographers",
        "Cosmographic", "Cosmographical", "Cosmography",
        "Cosmolatry", "Cosmologic", "Cosmological",
        "Cosmologist", "Cosmologists", "Cosmology",
        "Cosmonaut", "Cosmonauts", "Cosmonautic",
        "Cosmopolis", "Cosmopolitan", "Cosmopolitans",
        "Cosmopolitanism", "Cosmopolite", "Cosmopolites",
        "Cosmopolitism", "Cosmorama", "Cosmoramas",
        "Cosmos", "Cosmoses", "Cosmosphere",
        "Cosmotron", "Cosmotrons",
        "Cossack", "Cossacks",
        "Cosset", "Cossets", "Cosseted",
        "Cost", "Costs", "Costa", "Costae",
        "Costal", "Costalgia", "Costally",
        "Costard", "Costards", "Costate",
        "Costermonger", "Costermongers",
        "Costful", "Costing", "Costless",
        "Costly", "Costlier", "Costliest",
        "Costmary", "Costrel", "Costrels",
        "Costume", "Costumes", "Costumed",
        "Costumer", "Costumers", "Costumier",
        "Costus", "Costuses",
        
        "Of", "Ofay", "Ofays", "Off", "Offal", "Offals",
        "Offbeat", "Offbeats", "Offcast", "Offcasts",
        "Offcut", "Offcuts", "Offed",
        "Offence", "Offences", "Offenceless",
        "Offend", "Offended", "Offender", "Offenders",
        "Offending", "Offends",
        "Offense", "Offenses", "Offenseless",
        "Offensive", "Offensives", "Offensively",
        "Offensiveness",
        "Offer", "Offers", "Offerable",
        "Offeree", "Offerees", "Offerer", "Offerers",
        "Offering", "Offerings", "Offertory",
        "Offhand", "Offhanded", "Offhandedly",
        "Office", "Offices", "Officeholder",
        "Officer", "Officers", "Officered",
        "Official", "Officials", "Officialdom",
        "Officialese", "Officialism",
        "Officialize", "Officialized", "Officially",
        "Officiant", "Officiants",
        "Officiate", "Officiated", "Officiates",
        "Officiating", "Officiator",
        "Officinal", "Officious", "Officiously",
        "Offing", "Offings", "Offish",
        "Offlap", "Offload", "Offloaded",
        "Offprint", "Offprints", "Offput",
        "Offs", "Offsaddle",
        "Offscourings", "Offscum",
        "Offseason", "Offseasons",
        "Offset", "Offsets", "Offsetting",
        "Offshoot", "Offshoots",
        "Offshore", "Offshored", "Offshores",
        "Offside", "Offsides",
        "Offspring", "Offsprings",
        "Offstage", "Offtake", "Offtakes",
        "Offwhite", "Offwhites",
        
        "Alp", "Alps", "Alpaca", "Alpacas",
        "Alpargata", "Alpargatas",
        "Alpenglow", "Alpenglows",
        "Alpenhorn", "Alpenhorns",
        "Alpenstock", "Alpenstocks",
        "Alpestrine", "Alpha", "Alphas",
        "Alphabet", "Alphabets",
        "Alphabetic", "Alphabetical", "Alphabetically",
        "Alphabetize", "Alphabetized", "Alphabetizing",
        "Alphanumeric", "Alphanumerical",
        "Alphas", "Alpine", "Alpinely",
        "Alpinism", "Alpinisms",
        "Alpinist", "Alpinists",
        "Alprazolam", "Alprazolams",
        
        "Esv", "Esva", "Esvac",
        "Esvade", "Esvaded", "Esvades",
        "Esvage", "Esvaged", "Esvages",
        "Esvail", "Esvails",
        "Esvain", "Esvains",
        "Esvair", "Esvairs",
        "Esvan", "Esvans",
        "Esvanish", "Esvanished", "Esvanishes",
        "Esvaporate", "Esvaporated", "Esvaporates",
        "Esvaporation", "Esvaporations",
        "Esvault", "Esvaults",
        "Esvelte", "Esvelter", "Esveltest",
        "Esvent", "Esvents",
        "Esver", "Esvers",
        "Esviate", "Esviated", "Esviates",
        "Esvict", "Esvicts", "Esvicted",
        "Esviction", "Esvictions",
        "Esvie", "Esvied", "Esvies",
        "Esvile", "Esviler", "Esvilest",
        "Esvilify", "Esvilified",
        "Esvince", "Esvinced", "Esvinces",
        "Esvine", "Esvined", "Esvines",
        "Esviolate", "Esviolated", "Esviolates",
        "Esviolation", "Esviolations",
        "Esvir", "Esviral",
        "Esvire", "Esvired", "Esvires",
        "Esvirgin", "Esvirginal",
        "Esviril", "Esvirile",
        "Esvirtue", "Esvirtues",
        "Esvis", "Esvisage", "Esvisaged",
        "Esviscera", "Esvisceral",
        "Esviscerate", "Esviscerated",
        "Esvisco", "Esviscoid",
        "Esvise", "Esvised",
        "Esvisible", "Esvisibly",
        "Esvision", "Esvisions",
        "Esvisit", "Esvisits", "Esvisited",
        "Esvisitor", "Esvisitors",
        "Esvisor", "Esvisors",
        "Esvista", "Esvistas",
        "Esvisual", "Esvisualise", "Esvisualised",
        "Esvisualize", "Esvisualized",
        "Esvital", "Esvitally",
        "Esvitiate", "Esvitiated",
        "Esvitre", "Esvitreous",
        "Esvitric", "Esvitrics",
        "Esvitrify", "Esvitrified",
        "Esvitriol", "Esvitriolic",
        "Esvivace", "Esvivacious",
        "Esvive", "Esvived",
        "Esvivid", "Esvividly",
        "Esvivify", "Esvivified",
        "Esviviparous", "Esvivisect", "Esvivisected",
        "Esvocal", "Esvocals",
        "Esvocation", "Esvocations",
        "Esvocative", "Esvociferate",
        "Esvogue", "Esvogued",
        "Esvoke", "Esvoked", "Esvokes",
        "Esvol", "Esvola",
        "Esvolatile", "Esvolatility",
        "Esvolcanic", "Esvolcanically",
        "Esvolcano", "Esvolcanos",
        "Esvolent", "Esvolently",
        "Esvolitant", "Esvolitate",
        "Esvolition", "Esvolitions",
        "Esvolt", "Esvoltaic",
        "Esvoltmeter", "Esvolts",
        "Esvoluble", "Esvolubleness",
        "Esvolume", "Esvolumed",
        "Esvolumetric", "Esvoluminous",
        "Esvoluntary", "Esvoluntarily",
        "Esvolunteer", "Esvolunteered",
        "Esvoluptuous", "Esvoluptuously",
        "Esvolute", "Esvoluted",
        "Esvolution", "Esvolutions",
        "Esvolutionary", "Esvolutionist",
        "Esvolve", "Esvolved", "Esvolves",
        "Esvomit", "Esvomited", "Esvomiting",
        "Esvoodoo", "Esvoodoos",
        "Esvoracious", "Esvoraciously",
        "Esvoracity", "Esvoracities",
        "Esvortex", "Esvortexes",
        "Esvortical", "Esvortices",
        "Esvote", "Esvoted", "Esvotes",
        "Esvotive", "Esvotively",
        "Esvouch", "Esvouched",
        "Esvows", "Esvox",
        "Esvoyage", "Esvoyaged", "Esvoyager",
        "Esvoyeur", "Esvoyeurs",
    }
}

local palavrasES = {
    ["CURTAS"] = {
        "A", "O", "E", "I", "U", "Y", "Al", "Am", "An", "Ar", "As", "Ay",
        "Be", "Bi", "Bo", "Bu", "Ca", "Ce", "Ci", "Co", "Cu", "Da", "De", "Di", "Do", "Du",
        "El", "En", "Es", "Ex", "Fa", "Fe", "Fi", "Fo", "Fu",
        "Ga", "Ge", "Gi", "Go", "Gu", "Ha", "He", "Hi", "Ho", "Hu",
        "Ia", "Io", "Ir", "Is", "It",
        "La", "Le", "Li", "Lo", "Lu",
        "Ma", "Me", "Mi", "Mo", "Mu",
        "Na", "Ne", "Ni", "No", "Nu",
        "Oh", "Oi", "Ol", "Om", "On", "Or", "Os", "Ou", "Ox",
        "Pa", "Pe", "Pi", "Po", "Pu", "Qu", "Ra", "Re", "Ri", "Ro", "Ru",
        "Sa", "Se", "Si", "So", "Su", "Ta", "Te", "Ti", "To", "Tu",
        "Un", "Una", "Unas", "Unos", "Va", "Ve", "Vi", "Vo", "Vu",
        "Ya", "Ye", "Yi", "Yo", "Yu", "Za", "Ze", "Zi", "Zo", "Zu",
        "Ic", "Ica", "Ice", "Ico", "Icu",
        "Um", "Uma", "Ume", "Umi", "Umo",
        "Sac", "Saca", "Sace", "Saci", "Saco", "Sacu",
        "Cos", "Cosa", "Cose", "Cosi", "Coso", "Cosu",
        "Of", "Ofa", "Ofe", "Ofi", "Ofo", "Ofu",
        "Alp", "Alpa", "Alpe", "Alpi", "Alpo", "Alpu",
        "Esv", "Esva", "Esve", "Esvi", "Esvo", "Esvu",
        "Eo", "Eol", "Eon", "Eos"
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
        "Zona", "Zoo", "Zapato", "Zanahoria",
        
        -- EO Words
        "Eolico", "Eolicos", "Eolica", "Eolicas", "Eolismo", "Eolismos",
        "Eon", "Eones", "Eonio", "Eonios",
        "Eosina", "Eosinas", "Eosinofilo", "Eosinofilos",
        "Eosinofilia", "Eosinofilias",
        
        "Icaco", "Icacos", "Icaro", "Icaros",
        "Iceberg", "Icebergs",
        "Iciclo", "Iciclos", "Icnita", "Icnitas",
        "Icnofosil", "Icnofosiles",
        "Icnologia", "Icnologico",
        "Icono", "Iconos", "Iconico", "Iconicos",
        "Iconoclasta", "Iconoclastas",
        "Iconografia", "Iconografias",
        "Iconografico", "Iconograficos",
        "Iconolatra", "Iconolatras",
        "Iconolatria", "Iconolatrias",
        "Iconologia", "Iconologias",
        "Iconologico", "Iconologicos",
        "Iconoscopio", "Iconoscopios",
        "Iconostasio", "Iconostasios",
        "Icor", "Icores",
        "Icosaedro", "Icosaedros",
        "Ictericia", "Ictericias",
        "Icterico", "Ictericos",
        "Ictiofagia", "Ictiofago",
        "Ictiologia", "Ictiologico",
        "Ictiologo", "Ictiologos",
        "Ictiosauro", "Ictiosauros",
        
        "Umbela", "Umbelas", "Umbelifero", "Umbeliferos",
        "Umbilical", "Umbilicales", "Umbilicado", "Umbilicados",
        "Umbral", "Umbrales", "Umbra", "Umbras",
        "Umbrela", "Umbrelas", "Umbria", "Umbrias",
        "Umbrio", "Umbrios", "Umbroso", "Umbrosa",
        "Umedecer", "Umedecido", "Umedecida",
        "Umedo", "Umedos", "Umeda", "Umedas",
        "Umita", "Umitas",
        "Umbilicar", "Umbilicado", "Umbilicacion",
        
        "Saca", "Sacas", "Sacada", "Sacadas", "Sacado", "Sacados",
        "Sacabocado", "Sacabocados", "Sacabotas",
        "Sacacorchos", "Sacapuntas",
        "Sacarina", "Sacarinas", "Sacarificar", "Sacarificado",
        "Sacaro", "Sacaros",
        "Sacerdocio", "Sacerdocios", "Sacerdotal", "Sacerdotales",
        "Sacerdote", "Sacerdotes", "Sacerdotisa", "Sacerdotisas",
        "Sachar", "Sachado", "Sachada", "Sacho", "Sachos",
        "Saciar", "Saciado", "Saciada", "Saciable", "Saciables",
        "Saco", "Sacos", "Sacola", "Sacolas",
        "Sacramento", "Sacramentos", "Sacramental", "Sacramentales",
        "Sacrificar", "Sacrificado", "Sacrificio", "Sacrificios",
        "Sacrilego", "Sacrilegos", "Sacrilegio", "Sacrilegios",
        "Sacro", "Sacros", "Sacrosanto", "Sacrosantos",
        "Sacudir", "Sacudido", "Sacudida", "Sacudimiento",
        "Saculo", "Saculos", "Sacular", "Saculares",
        
        "Cosa", "Cosas", "Cosaco", "Cosacos", "Cosaca", "Cosacas",
        "Coscar", "Coscado", "Coscoja", "Coscojas", "Coscojo", "Coscojos",
        "Coscorron", "Coscorrones", "Cosecante", "Cosecantes",
        "Cosecha", "Cosechas", "Cosechar", "Cosechado", "Cosechadora",
        "Coser", "Cosido", "Cosidos", "Cosida", "Cosidas",
        "Cosmetico", "Cosmeticos", "Cosmetica", "Cosmeticas",
        "Cosmico", "Cosmicos", "Cosmica", "Cosmicas",
        "Cosmo", "Cosmos", "Cosmogonico", "Cosmogonicos",
        "Cosmogonia", "Cosmogonias", "Cosmografia", "Cosmografias",
        "Cosmografico", "Cosmograficos", "Cosmologo", "Cosmologos",
        "Cosmologia", "Cosmologias", "Cosmologico", "Cosmologicos",
        "Cosmonauta", "Cosmonautas", "Cosmopolita", "Cosmopolitas",
        "Cosmopolitismo", "Cosmopolitismos", "Cosmorama", "Cosmoramas",
        "Cosmovision", "Cosmovisiones", "Coso", "Cosos",
        "Cosquillas", "Cosquillear", "Cosquilleo", "Cosquilleos",
        "Costa", "Costas", "Costado", "Costados", "Costal", "Costales",
        "Costar", "Costado", "Coste", "Costes", "Costero", "Costeros",
        "Costilla", "Costillas", "Costillar", "Costillares",
        "Costo", "Costos", "Costoso", "Costosos", "Costosa", "Costosas",
        "Costumbre", "Costumbres", "Costura", "Costuras",
        "Costurar", "Costurado", "Costurera", "Costureras",
        
        "Ofa", "Ofas", "Ofelia", "Ofelias",
        "Ofender", "Ofendido", "Ofendida", "Ofendidos", "Ofendidas",
        "Ofensa", "Ofensas", "Ofensivo", "Ofensivos", "Ofensiva", "Ofensivas",
        "Ofensor", "Ofensores", "Ofensora", "Ofensoras",
        "Ofertar", "Ofertado", "Ofertada", "Oferta", "Ofertas",
        "Ofertorio", "Ofertorios", "Oferente", "Oferentes",
        "Oficial", "Oficiales", "Oficialmente", "Oficialidad",
        "Oficiar", "Oficiado", "Oficiante", "Oficiantes",
        "Oficina", "Oficinas", "Oficinista", "Oficinistas",
        "Ofidio", "Ofidios", "Ofidico", "Ofidicos",
        "Ofiologia", "Ofiologias", "Ofiologico", "Ofiologicos",
        "Ofita", "Ofitas", "Ofitico", "Ofiticos",
        "Oftalmia", "Oftalmias", "Oftalmico", "Oftalmicos",
        "Oftalmologia", "Oftalmologias", "Oftalmologico",
        "Oftalmologo", "Oftalmologos", "Oftalmoscopio",
        "Ofuscante", "Ofuscantes", "Ofuscar", "Ofuscado",
        "Ofuscacion", "Ofuscaciones", "Ofuscamiento",
        
        "Alpaca", "Alpacas", "Alparca", "Alparcas",
        "Alpargata", "Alpargatas", "Alpargatero", "Alpargateros",
        "Alpax", "Alpaxes", "Alpe", "Alpes",
        "Alpestre", "Alpestres", "Alpico", "Alpicos",
        "Alpinismo", "Alpinismos", "Alpinista", "Alpinistas",
        "Alpino", "Alpinos", "Alpina", "Alpinas",
        "Alpiste", "Alpistes", "Alpistero", "Alpisteros",
        "Alpo", "Alpos", "Alpujarra", "Alpujarras",
        "Alquimia", "Alquimias", "Alquimico", "Alquimicos",
        "Alquimista", "Alquimistas", "Alquitar", "Alquitado",
        "Alquitrabe", "Alquitrabes",
        "Alcor", "Alcores", "Alcoranico", "Alcoranicos",
        "Alcova", "Alcovas",
        "Alcuza", "Alcuzas", "Alcuzado", "Alcuzados",
        "Aldea", "Aldeas", "Aldeano", "Aldeanos",
        "Aldehuela", "Aldehuelas", "Aldeita", "Aldeitas",
        
        "Esvair", "Esvais", "Esvae", "Esvaen",
        "Esvaido", "Esvaidos", "Esvaida", "Esvaidas",
        "Esvanecer", "Esvanecido", "Esvanecida",
        "Esvanecimiento", "Esvanecimientos",
        "Esvaporar", "Esvaporado", "Esvaporada",
        "Esvaporacion", "Esvaporaciones",
        "Esvasar", "Esvasado", "Esvasada",
        "Esvasadura", "Esvasaduras",
        "Esvelto", "Esveltos", "Esvelta", "Esveltas",
        "Esveltez", "Esvelteces", "Esvelteza", "Esveltezas",
        "Esvirar", "Esvirado", "Esvirada",
        "Esviril", "Esviriles", "Esvirilar", "Esvirilado",
        "Esviscerar", "Esviscerado", "Esviscerada",
        "Esvitar", "Esvitado", "Esvitada",
        "Esvoacar", "Esvoacado", "Esvoacada",
        "Esvoacante", "Esvoacantes",
        "Esvol", "Esvoles", "Esvolar", "Esvolado",
        "Esvolumen", "Esvolumenes", "Esvoluminoso",
        "Esvotar", "Esvotado", "Esvotada",
        "Esvult", "Esvultos",
        "Esvulgar", "Esvulgado", "Esvulgada",
        "Esvulnerar", "Esvulnerado", "Esvulnerada",
    }
}

local palavrasHardMode = {
    Y = {"yabby", "yacht", "yachts", "yachting", "yachtsman", "yak", "yaks", "yam", "yams", "yank", "yanks", "yap", "yaps", "yard", "yards", "yarn", "yarns", "yaw", "yaws", "yawn", "yawns", "yea", "yeah", "year", "years", "yearly", "yearn", "yearns", "yeast", "yeasts", "yell", "yells", "yellow", "yellows", "yelp", "yelps", "yen", "yens", "yep", "yes", "yet", "yew", "yews", "yield", "yields", "yoga", "yogurt", "yogurts", "yoke", "yokes", "yolk", "yolks", "you", "young", "younger", "your", "yours", "youth", "youths", "youtube", "yuck", "yucky", "yule", "yum", "yummy", "yurt", "yurts"},
    W = {"allow", "arrow", "below", "blow", "borrow", "bow", "brew", "brow", "chew", "claw", "cow", "crew", "dew", "draw", "drew", "elbow", "few", "flow", "follow", "grew", "grow", "how", "jaw", "knew", "know", "law", "low", "narrow", "new", "now", "pillow", "plow", "raw", "renew", "row", "saw", "sew", "shadow", "show", "slow", "snow", "sow", "sparrow", "spew", "stew", "straw", "swallow", "thaw", "throw", "tomorrow", "tow", "view", "vow", "widow", "willow", "yellow"},
    LY = {"actually", "barely", "basically", "beautifully", "briefly", "carefully", "certainly", "clearly", "closely", "commonly", "completely", "constantly", "currently", "daily", "deeply", "definitely", "directly", "easily", "effectively", "entirely", "equally", "especially", "eventually", "exactly", "extremely", "fairly", "finally", "firmly", "formerly", "frequently", "fully", "generally", "gently", "gladly", "greatly", "hardly", "heavily", "highly", "honestly", "immediately", "increasingly", "initially", "jointly", "kindly", "largely", "lately", "likely", "literally", "lonely", "mainly", "merely", "mostly", "nearly", "necessarily", "newly", "normally", "obviously", "occasionally", "originally", "partially", "particularly", "perfectly", "personally", "physically", "poorly", "possibly", "precisely", "presently", "presumably", "previously", "primarily", "probably", "properly", "publicly", "quickly", "quietly", "rarely", "readily", "really", "recently", "relatively", "repeatedly", "reportedly", "roughly", "routinely", "sadly", "scarcely", "seemingly", "separately", "seriously", "severely", "shortly", "significantly", "similarly", "simply", "slightly", "slowly", "smoothly", "solely", "specifically", "steadily", "strictly", "strongly", "suddenly", "sufficiently", "supposedly", "surely", "tightly", "totally", "truly", "typically", "ultimately", "undoubtedly", "unfortunately", "unlikely", "usually", "virtually", "widely", "willingly"},
    XX = {"box", "fox", "fix", "mix", "six", "tax", "wax", "axe", "hex", "jinx", "lynx", "max", "next", "ox", "relax", "remix", "sex", "sixty", "text", "vex", "annex", "apex", "complex", "crux", "duplex", "flex", "flux", "helix", "hoax", "ibex", "index", "latex", "matrix", "onyx", "paradox", "phoenix", "prefix", "reflex", "sphinx", "suffix", "syntax", "thorax", "vertex", "vortex", "xerox"},
    POP = {"pop", "pops", "popcorn", "popcorns", "pope", "popes", "poplar", "poplars", "poppy", "poppies", "popular", "popularly", "popularity", "popularize", "popularized", "popularizing", "populate", "populated", "populates", "populating", "population", "populations", "populist", "populists", "populism", "populous", "popup", "popups", "popover", "popovers", "popinjay", "popinjays", "popish", "popishly", "popliteal", "poplin", "poplins", "popsicle", "popsicles", "populace", "populaces", "poppyseed", "poppyseeds", "popgun", "popguns", "popery", "poperies", "popedom", "popedoms"},
    EO = {"eon", "eons", "eonian", "eonism", "eonisms", "eolithic", "eosin", "eosinophil", "eosinophils", "eosinophilia", "eosinophilic", "eohippus", "eohippuses", "eolian", "eolic", "eolienne", "eolipile", "eolipiles", "eolithic", "eolopile", "eolopiles", "eos", "eosate", "eosates", "eosin", "eosins", "eosine", "eosines", "eosinic", "eosinophil", "eosinophilic", "eosinophilia", "eosinophilias", "eosinopenic", "eosinopenias", "eosinopenic", "eosinopenia"}
}

local hardModeCategorias = {"Y", "W", "LY", "XX", "POP", "EO"}

local coreGui = game:GetService("CoreGui") or game:GetService("StarterGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VortexAutoType"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.Parent = coreGui

local PADDING = 14
local scriptAtivo = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(45, 45, 70)
stroke.Thickness = 1.5

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, PADDING, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Vortex - Finish The Word"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 11
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -64, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 11
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.ZIndex = 11
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -PADDING*2, 1, -36 - PADDING*2)
contentContainer.Position = UDim2.new(0, PADDING, 0, 36 + PADDING)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 10
contentContainer.Parent = mainFrame

local isMinimized = false
local originalSize = UDim2.new(0, 600, 0, 400)
local minimizedSize = UDim2.new(0, 400, 0, 36)
local animating = false

local function animateMinimize(targetSize, callback)
    if animating then return end
    animating = true
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    
    tween:Play()
    tween.Completed:Wait()
    animating = false
    
    if callback then
        callback()
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    if animating then return end
    
    if isMinimized then
        animateMinimize(originalSize, function()
            contentContainer.Visible = true
            minimizeBtn.Text = "−"
            titleLabel.Text = "Vortex - Finish The Word"
            mainFrame.Size = originalSize
        end)
    else
        contentContainer.Visible = false
        animateMinimize(minimizedSize, function()
            minimizeBtn.Text = "+"
            titleLabel.Text = "Vortex"
            mainFrame.Size = minimizedSize
        end)
    end
    isMinimized = not isMinimized
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
statusFrame.Size = UDim2.new(1, 0, 0, 44)
statusFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
statusFrame.ZIndex = 10
statusFrame.Parent = leftFrame
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", statusFrame).Color = Color3.fromRGB(0, 170, 100)

local powerToggle = Instance.new("TextButton")
powerToggle.Size = UDim2.new(0, 40, 0, 22)
powerToggle.Position = UDim2.new(1, -PADDING - 40, 0.5, -11)
powerToggle.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
powerToggle.Text = "ON"
powerToggle.TextColor3 = Color3.fromRGB(20, 20, 20)
powerToggle.Font = Enum.Font.GothamBold
powerToggle.TextSize = 11
powerToggle.ZIndex = 11
powerToggle.Parent = statusFrame
Instance.new("UICorner", powerToggle).CornerRadius = UDim.new(0, 10)

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
greenDot.Size = UDim2.new(0, 8, 0, 8)
greenDot.Position = UDim2.new(0, PADDING, 0.5, -4)
greenDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
greenDot.ZIndex = 10
greenDot.Parent = statusFrame
Instance.new("UICorner", greenDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -110, 1, 0)
statusLabel.Position = UDim2.new(0, 28, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Waiting for your turn..."
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.ZIndex = 10
statusLabel.Parent = statusFrame

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 1, -56)
toggleFrame.Position = UDim2.new(0, 0, 0, 56)
toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
toggleFrame.ZIndex = 10
toggleFrame.Parent = leftFrame
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)

local function createToggleContainer(parent, yPos, height, title, desc, defaultEnabled)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -PADDING*2, 0, height)
    container.Position = UDim2.new(0, PADDING, 0, yPos)
    container.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", container).Color = Color3.fromRGB(50, 50, 70)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 18)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🟢 " .. title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 10
    titleLabel.Parent = container
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 14)
    descLabel.Position = UDim2.new(0, 10, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(140, 140, 170)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 8
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 10
    descLabel.Parent = container
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -20, 0, 26)
    toggleBtn.Position = UDim2.new(0, 10, 0, height - 34)
    toggleBtn.BackgroundColor3 = defaultEnabled and Color3.fromRGB(30, 60, 30) or Color3.fromRGB(50, 50, 65)
    toggleBtn.Text = defaultEnabled and "ENABLED" or "DISABLED"
    toggleBtn.TextColor3 = defaultEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.ZIndex = 11
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 5)
    
    return titleLabel, toggleBtn, container
end

local CONTAINER_HEIGHT = 80
local CONTAINER_GAP = 12

local hardModeTitle, hardToggleBtn, hardContainer = createToggleContainer(
    toggleFrame, 
    8, 
    CONTAINER_HEIGHT, 
    "Hard Mode", 
    "Random: Y, W, LY, X, POP, EO endings", 
    true
)

local safeModeTitle, safeToggleBtn, safeContainer = createToggleContainer(
    toggleFrame, 
    8 + CONTAINER_HEIGHT + CONTAINER_GAP, 
    CONTAINER_HEIGHT, 
    "Safe Mode", 
    "Stops after 4 attempts, waits for you", 
    true
)

local fastModeTitle, fastToggleBtn, fastContainer = createToggleContainer(
    toggleFrame, 
    8 + (CONTAINER_HEIGHT + CONTAINER_GAP) * 2, 
    CONTAINER_HEIGHT, 
    "Fast Typing", 
    "Randomized slow typing speed", 
    false
)

local hardMode = true
local safeMode = true
local fastMode = false

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

fastToggleBtn.MouseButton1Click:Connect(function()
    fastMode = not fastMode
    if fastMode then
        fastToggleBtn.Text = "ENABLED"
        fastToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        fastToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        fastModeTitle.Text = "🟢 Fast Typing"
    else
        fastToggleBtn.Text = "DISABLED"
        fastToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        fastToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        fastModeTitle.Text = "🔴 Fast Typing"
    end
end)

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.49, 0, 1, 0)
rightFrame.Position = UDim2.new(0.51, 0, 0, 0)
rightFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
rightFrame.ZIndex = 10
rightFrame.Parent = contentContainer
Instance.new("UICorner", rightFrame).CornerRadius = UDim.new(0, 8)

local detalhesLabel = Instance.new("TextLabel")
detalhesLabel.Size = UDim2.new(1, 0, 0, 20)
detalhesLabel.Position = UDim2.new(0, 0, 0, PADDING)
detalhesLabel.BackgroundTransparency = 1
detalhesLabel.Text = "Session Details"
detalhesLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
detalhesLabel.Font = Enum.Font.GothamBold
detalhesLabel.TextSize = 13
detalhesLabel.TextXAlignment = Enum.TextXAlignment.Center
detalhesLabel.ZIndex = 10
detalhesLabel.Parent = rightFrame

local ROW_HEIGHT = 32
local ROW_PADDING = 10
local ROW_GAP = 42

local function createInfoRow(parent, yPos, labelText, valueText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -PADDING*2, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, PADDING, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    row.ZIndex = 10
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.42, 0, 1, 0)
    label.Position = UDim2.new(0, ROW_PADDING, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(160, 160, 190)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
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
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 10
    value.Parent = row
    
    return value
end

local rightStartY = PADDING + 26
local detIdioma   = createInfoRow(rightFrame, rightStartY + ROW_GAP*0, "Language", "EN")
local detPalavras = createInfoRow(rightFrame, rightStartY + ROW_GAP*1, "Available", "0")
local detMesa     = createInfoRow(rightFrame, rightStartY + ROW_GAP*2, "Table", "-")
local detPalavra  = createInfoRow(rightFrame, rightStartY + ROW_GAP*3, "Prefix", "0")
local detUsadas   = createInfoRow(rightFrame, rightStartY + ROW_GAP*4, "Used", "0")
local detErros    = createInfoRow(rightFrame, rightStartY + ROW_GAP*5, "Strikes", "0")

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
    local primeiraLetra = prefixo:sub(1, 1):upper()
    local duasLetras = prefixo:sub(1, 2):upper()
    local tresLetras = prefixo:sub(1, 3):upper()
    
    if hardMode then
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
    
    if #candidatas == 0 and palavrasCategoria["COMPLETAS"] then
        for _, p in pairs(palavrasCategoria["COMPLETAS"]) do
            local pu = p:upper()
            if pu:sub(1, #prefixo) == prefixo and not tentadas[pu] then
                table.insert(candidatas, p)
            end
        end
    end
    
    if #candidatas == 0 and palavrasCategoria["CURTAS"] then
        for _, p in pairs(palavrasCategoria["CURTAS"]) do
            local pu = p:upper()
            if pu:sub(1, #prefixo) == prefixo and pu ~= prefixo and not tentadas[pu] then
                table.insert(candidatas, p)
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
    
    local screen = playerGui:FindFirstChild("ScreenGui") or playerGui:FindFirstChild("screenGui")
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

local function getFastSpeedMultiplier()
    local speeds = {0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8}
    return speeds[math.random(1, #speeds)]
end

local function apagarLetras(qtd)
    if qtd <= 0 then return end
    
    local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
    
    local delayBackspace = fastMode and (0.06 * speedMultiplier) or 0.04
    local delayBetween = fastMode and (0.04 * speedMultiplier) or 0.03
    local delayAfter = fastMode and (0.08 * speedMultiplier) or 0.1
    
    for i = 1, qtd do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, nil)
        task.wait(delayBackspace)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, nil)
        task.wait(delayBetween)
    end
    task.wait(delayAfter)
end

local function digitarResto(palavra, base)
    local resto = palavra:sub(#base + 1)
    
    local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
    
    local delayEnterBefore = fastMode and (0.15 * speedMultiplier) or 0.25
    local delayEnterAfter = fastMode and (0.08 * speedMultiplier) or 0.10
    local delayKeyDown = fastMode and (0.08 * speedMultiplier) or 0.10
    local delayKeyUp = fastMode and (0.06 * speedMultiplier) or 0.08
    local delayRandomMin = fastMode and (0.04 * speedMultiplier) or 0.04
    local delayRandomMax = fastMode and (0.06 * speedMultiplier) or 0.06
    local delayAfterEnter = fastMode and (0.12 * speedMultiplier) or 0.25
    
    if resto == "" then
        task.wait(delayEnterBefore)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
        task.wait(delayEnterAfter)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
        return 0
    end
    for letra in resto:gmatch(".") do
        local keyCode = Enum.KeyCode[letra:upper()]
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
            task.wait(delayKeyDown + math.random() * delayRandomMin)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
            task.wait(delayKeyUp + math.random() * delayRandomMax)
        end
    end
    task.wait(delayAfterEnter)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
    task.wait(delayEnterAfter)
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
            
            local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
            local delayEnterBefore = fastMode and (0.06 * speedMultiplier) or 0.08
            local delayEnterAfter = fastMode and (0.04 * speedMultiplier) or 0.08
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
            task.wait(delayEnterBefore)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, nil)
            task.wait(delayEnterAfter)
            
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
            local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
            local choiceDelay = fastMode and (1.5 * speedMultiplier) or 1.5
            
            if agora - ultimoTempoChoice > choiceDelay then
                ultimoTempoChoice = agora
                
                local fezEscolha = false
                pcall(function()
                    fezEscolha = autoEscolherLetra()
                end)
                
                if fezEscolha then
                    escolhaJaFeita = true
                    task.wait(fastMode and (0.4 * speedMultiplier) or 0.5)
                end
            end
        end
        task.wait(fastMode and 0.15 or 0.3)
    end
end)

while scriptAtivo do
    local inGame, isTurn = getPlayerAttributes()
    
    if not botAtivo then
        atualizarInterface("PAUSED - Click ON to resume", idioma, 0, "-", "0")
        verificando = false
        tentativas = 0
        escolhaJaFeita = false
        task.wait(0.2)
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
        task.wait(0.2)
        continue
    end
    
    if not escolhaJaFeita then
        local fezEscolha = false
        pcall(function()
            fezEscolha = autoEscolherLetra()
        end)
        if fezEscolha then
            escolhaJaFeita = true
            local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
            task.wait(fastMode and (0.4 * speedMultiplier) or 0.5)
        end
    end
    
    local matchDisplay, mesaNumero = findMyTable(inGame)
    
    if matchDisplay then
        temHydra = temPetHydraNaMesa(inGame)
        local prefixo = getPrefixo(matchDisplay)
        local palavraPet = getPalavraDoPet(matchDisplay, temHydra)
        
        local baseAgora = ""
        local speedMultiplier = fastMode and getFastSpeedMultiplier() or 1.0
        
        if palavraPet ~= "" then
            baseAgora = palavraPet
            TEMPO_VERIFICACAO = fastMode and (1.5 * speedMultiplier) or 1.5
        elseif prefixo then
            baseAgora = prefixo
            TEMPO_VERIFICACAO = fastMode and (1.2 * speedMultiplier) or 1.2
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
                task.wait(0.2)
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
                    local delayInicialMin = fastMode and (0.5 * speedMultiplier) or 0.5
                    local delayInicialMax = fastMode and (0.8 * speedMultiplier) or 0.8
                    local delayInicial = delayInicialMin + math.random() * delayInicialMax
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
    
    task.wait(fastMode and 0.1 or 0.1)
end