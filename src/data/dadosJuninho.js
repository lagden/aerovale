{
    "cidades": [{
        "id": 5,
        "nome": "Belo Horizonte",
        "lat": 362,
        "lon": 424,
        "sigla": "BHZ"
    }, {
        "id": 6,
        "nome": "Rio de Janeiro",
        "lat": 407,
        "lon": 437,
        "sigla": "RIO"
    }, {
        "id": 7,
        "nome": "Carajás",
        "lat": 160,
        "lon": 345,
        "sigla": "CKS"
    }, {
        "id": 9,
        "nome": "Marabá",
        "lat": 150,
        "lon": 360,
        "sigla": "MAB"
    }, {
        "id": 10,
        "nome": "Ourilândia do Norte",
        "lat": 170,
        "lon": 320,
        "sigla": "OIA"
    }],
    "voos": [{
        "origem": "BHZ",
        "destinos": ["RIO", "CKS"]
    }, {
        "origem": "RIO",
        "destinos": ["BHZ"]
    }, {
        "origem": "CKS",
        "destinos": ["BHZ", "OIA"]
    }, {
        "origem": "MAB",
        "destinos": ["OIA", "CKS"]
    }, {
        "origem": "OIA",
        "destinos": ["MAB", "CKS"]
    }]
}