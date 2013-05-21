var swfVersionStr = "11.1.0";
var xiSwfUrlStr = "playerProductInstall.swf";
var flashvars = {};
var params = {
      wmode: "transparent"
    , quality: "high"
    , bgcolor: "#000000"
    , allowscriptaccess: "sameDomain"
    , allowfullscreen: "true"
};
var attributes = {
      id: "aerovale"
    , name: "aerovale"
    , align: "middle"
};
swfobject.embedSWF(
      "Aerovale.swf?noCache=" + new Date().getTime()
    , "flashContentAerovale"
    , "700", "670"
    , swfVersionStr
    , xiSwfUrlStr
    , flashvars
    , params
    , attributes
);
swfobject.createCSS("#flashContentAerovale", "display:block;text-align:left;");

var fulldata = {}
    , cidades = {}
    , $destino = $('#destino')
    , $origem = $('#origem')
    , $resultadoAerovale = $('#resultadoAerovale')
    , $direcaoAerovale = $('#direcaoAerovale')
    ;

$.getJSON('data/dadosJuninho.js', function(res) {
    $origem.find('option').remove();
    $origem.append('<option value="">Selecione</option>');

    $.each(res.cidades, function(k, v) {
        cidades[v.sigla] = {
            "nome": v.nome,
            "aeroporto": v.aeroporto
        };
        $origem.append('<option value="'+v.sigla+'">'+v.nome+'</option>');
    });
    $.each(res.voos, function(k, v) {
        $.extend(cidades[v.origem], {"destinos": v.destinos});
    });
});

$.getJSON('data/dadosFull.js', function(res) {
    fulldata = res;
});

$origem.on('change', {"destino": $destino}, function(ev) {
    ev.data.destino.find('option').remove();
    ev.data.destino.append('<option value="">Todos</option>');
    $.each(cidades[this.value].destinos, function(k, v) {
        ev.data.destino.append('<option value="'+v+'">'+cidades[v].nome+'</option>');
    });
});

window.onload = (function() {
    return function() {
        $('#frmFiltroAeronave')
        .on('submit', function(ev) {
            ev.preventDefault();
            var o = $('#origem').val();
            var d = $('#destino').val();
            d = d || null;
            renderResult(o, d);
            if(o)
            {
                var obj = swfobject.getObjectById("aerovale");
                if (obj)
                    obj.origemDestino(o, d);
            }
        });
    }
})();

function renderResultGroup(o)
{
    var cc = 0;
    var destinos = {}
    $resultadoAerovale.empty();
    $.each(fulldata, function(k, v){
        if(v.origem == o)
        {
            if(destinos[v.destino] == undefined) destinos[v.destino] = [];
            destinos[v.destino].push(templateFlights($.extend(v,{aeroporto: cidades[v.destino].aeroporto})));
            cc++;
        }
    });
    var str = '<ul>';
    $.each(destinos, function(k, v){
        str += '<li>';
        str += '<div class="handlerLista">'+cidades[k].nome+' ('+destinos[k].length+')</div>';
        str += '<div class="contentLista">';
        $.each(v, function(idx, tbl){
            str += tbl;
        });
        str += '</div>';
        str += '</li>';
    });
    str += '</ul>';

    $resultadoAerovale.append(str);

    $resultadoAerovale.find('.handlerLista').off('click').on('click',function(ev){
        var $this = $(this);
        $this.next().slideToggle("slow");
        $this.toggleClass('open');
    });

    var s = (cc > 1) ? 's' : '';
    $direcaoAerovale
    .empty()
    .html('Partindo de '+cidades[o].nome + ' <small>'+cc+' vôo'+s+' encontrado'+s+'</small>');
}

function renderResult(o, d)
{
    var cc = 0;
    if(o && d)
    {
        $resultadoAerovale.empty();
        $.each(fulldata, function(k, v){
            if(v.origem == o && v.destino == d)
            {
                $resultadoAerovale
                .append(templateFlights($.extend(v,{aeroporto: cidades[d].aeroporto})));
                cc++;
            }
        });
        var s = (cc > 1) ? 's' : '';
        $direcaoAerovale
        .empty()
        .html(cidades[o].nome + ' / ' + cidades[d].nome + ' <small>'+cc+' vôo'+s+' encontrado'+s+'</small>');
    }
    else if(o)
    {
        renderResultGroup(o);
    }
}

function templateFlights(o)
{
    var str = '\
    <table>\
        <tr>\
            <td>\
                <div class="media">\
                    <div class="media__img"><img src="images/blank.gif" class="i ir ico-calendar"></div>\
                    <div class="media__body">\
                        <b>' + o.aeronave + '</b><br>\
                        ' + o.diadasemana + '\
                    </div>\
                </div>\
            </td>\
            <td>\
                <div class="media">\
                    <div class="media__img"><img src="images/blank.gif" class="i ir ico-clock"></div>\
                    <div class="media__body">\
                        Partida: <b>' + o.horariopartida + '</b><br>\
                        Chegada: <b>' + o.horariochegada + '</b><br>\
                    </div>\
                </div>\
            </td>\
            <td>\
                <b>' + o.aeroporto.nome + '</b><br>\
                ' + o.aeroporto.endereco + '\
            </td>\
        </tr>\
    </table>';
    return str;
}

function destinosDe(origem)
{
    renderResult(origem, null);
}