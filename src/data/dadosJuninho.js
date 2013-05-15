{
    "cidades": [{
        "id": 5,
        "nome": "Belo Horizonte",
        "lat": 362,
        "lon": 424,
        "sigla": "BHZ",
        "aeroporto": {
            "id": 1,
            "nome": "Aeroporto Santos Dumont",
            "endereco": "Praça Senador Salgado Filho, s/nº, Centro, Rio de Janeiro, RJ",
            "observacao": "não tem"
        }
    }, {
        "id": 6,
        "nome": "Rio de Janeiro",
        "lat": 407,
        "lon": 437,
        "sigla": "RIO",
        "aeroporto": {
            "id": 1,
            "nome": "Aeroporto Santos Dumont",
            "endereco": "Praça Senador Salgado Filho, s/nº, Centro, Rio de Janeiro, RJ",
            "observacao": "não tem"
        }
    }, {
        "id": 7,
        "nome": "Carajás",
        "lat": 160,
        "lon": 345,
        "sigla": "CKS",
        "aeroporto": {
            "id": 1,
            "nome": "Aeroporto Santos Dumont",
            "endereco": "Praça Senador Salgado Filho, s/nº, Centro, Rio de Janeiro, RJ",
            "observacao": "não tem"
        }
    }, {
        "id": 9,
        "nome": "Marabá",
        "lat": 150,
        "lon": 360,
        "sigla": "MAB",
        "aeroporto": {
            "id": 1,
            "nome": "Aeroporto Santos Dumont",
            "endereco": "Praça Senador Salgado Filho, s/nº, Centro, Rio de Janeiro, RJ",
            "observacao": "não tem"
        }
    }, {
        "id": 10,
        "nome": "Ourilândia do Norte",
        "lat": 170,
        "lon": 320,
        "sigla": "OIA",
        "aeroporto": {
            "id": 1,
            "nome": "Aeroporto Santos Dumont",
            "endereco": "Praça Senador Salgado Filho, s/nº, Centro, Rio de Janeiro, RJ",
            "observacao": "não tem"
        }
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