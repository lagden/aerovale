var initTxt = 'Selecione um ponto no mapa ou utilize o filtro';
var swfVersionStr = "11.1.0";
var xiSwfUrlStr = "../Documents/playerProductInstall.swf";
var flashvars = {};
var params = {
    // wmode: "transparent",
    quality: "high",
    bgcolor: "#FFFFFF",
    allowscriptaccess: "sameDomain",
    allowfullscreen: "true"
};
var attributes = {
    id: "aerovale",
    name: "aerovale",
    align: "middle"
};
swfobject.embedSWF(
    "../Documents/Aerovale.swf?noCache=" + new Date().getTime(), "flashContentAerovale", "700", "670", swfVersionStr, xiSwfUrlStr, flashvars, params, attributes);
swfobject.createCSS("#flashContentAerovale", "display:block;text-align:left;");

var fulldata = {}, cidades = {}, $destino = $('#destino'),
    objFlash,
    $origem = $('#origem'),
    $resultadoAerovale = $('#resultadoAerovale'),
    $direcaoAerovale = $('#direcaoAerovale');

$direcaoAerovale.html(initTxt);

$.getJSON('../Documents/data/dadosJuninho.js', function(res) {
    $origem.find('option').remove();
    $origem.append('<option value="">Selecione</option>');

    $.each(res.cidades, function(k, v) {
        cidades[v.sigla] = {
            "nome": v.nome
        };
        $origem.append('<option value="' + v.sigla + '">' + v.nome + '</option>');
    });
    $.each(res.voos, function(k, v) {
        $.extend(cidades[v.origem], {
            "destinos": v.destinos
        });
    });
});

$.getJSON('../Documents/data/dadosFull.js', function(res) {
    fulldata = res;
});

$origem.on('change', {
    "destino": $destino
}, function(ev) {
    ev.data.destino.find('option').remove();
    ev.data.destino.append('<option value="">Todos</option>');
    $.each(cidades[this.value].destinos, function(k, v) {
        ev.data.destino.append('<option value="' + v + '">' + cidades[v].nome + '</option>');
    });
    ev.data.destino.trigger('change');
});

window.onload = (function() {
    return function() {
        $('#frmFiltroAeronaveBtn')
            .on('click', function(ev) {
            ev.preventDefault();
            var o = $('#origem').val();
            var d = $('#destino').val();
            d = d || null;
            renderResult(o, d);
            if (o) {
                objFlash = swfobject.getObjectById("aerovale");
                if (objFlash) objFlash.origemDestino(o, d);
                $('html, body').animate({ scrollTop: $direcaoAerovale.offset().top }, 500);
            }
        });
    }
})();

function renderResultGroup(o) {
    var cc = 0;
    var destinos = {}
    $resultadoAerovale.empty();
    $.each(fulldata, function(k, v) {
        if (v.origem == o) {
            if (destinos[v.destino] == undefined)
                destinos[v.destino] = [];

            destinos[v.destino].push( templateFlights(v) );
            cc++;
        }
    });
    var str = '<ul>';
    $.each(destinos, function(k, v) {
        str += '<li>';
        str += '<div class="handlerLista">Destino <b>' + cidades[k].nome + '</b> <small>(' + destinos[k].length + ')</small></div>';
        str += '<div class="contentLista">';
        $.each(v, function(idx, tbl) {
            str += tbl;
        });
        str += '</div>';
        str += '</li>';
    });
    str += '</ul>';

    $resultadoAerovale.append(str);

    $resultadoAerovale.find('.handlerLista').off('click').on('click', function(ev) {
        var $this = $(this);
        $this.next().slideToggle("slow");
        $this.toggleClass('open');
    });

    var s = (cc > 1) ? 's' : '';
    $direcaoAerovale.empty()
        .html('Partindo de ' + cidades[o].nome + ' <small>' + cc + ' voo' + s + ' encontrado' + s + '</small>');
}

function renderResult(o, d) {
    var cc = 0;
    if (o && d) {
        $resultadoAerovale.empty();
        $.each(fulldata, function(k, v) {
            if (v.origem == o && v.destino == d) {
                $resultadoAerovale.append( templateFlights(v) );
                cc++;
            }
        });
        var s = (cc > 1) ? 's' : '';
        $direcaoAerovale.empty()
            .html(cidades[o].nome + ' / ' + cidades[d].nome + ' <small>' + cc + ' voo' + s + ' encontrado' + s + '</small>');
    } else if (o) {
        renderResultGroup(o);
    }
}

function templateFlights(o) {
    var str = '\
    <table>\
        <tr>\
            <td>\
                <div class="media">\
                    <div class="media__img"><img src="../Documents/images/blank.gif" class="i ir ico-calendar"></div>\
                    <div class="media__body">\
                        <b>' + o.aeronave + '</b><br>\
                        ' + o.diadasemana + '\
                    </div>\
                </div>\
            </td>\
            <td>\
                <div class="media">\
                    <div class="media__img"><img src="../Documents/images/blank.gif" class="i ir ico-clock"></div>\
                    <div class="media__body">\
                        Partida: <b>' + o.horariopartida + '</b><br>\
                        Chegada: <b>' + o.horariochegada + '</b><br>\
                    </div>\
                </div>\
            </td>\
            <td>\
                <b>' + o.aeroporto_origem + '</b><br>\
                ' + o.endereco_origem + '\
            </td>\
        </tr>\
    </table>';
    return str;
}

function destinosDe(origem) {
    renderResult(origem, null);
}

// Custom combo
var $combos = $('.theCombo').theCombo();
$('#limparRota').on('click', function(ev) {
    ev.preventDefault();
    $combos.theCombo('reset');
    $direcaoAerovale.html(initTxt);
    $resultadoAerovale.empty();
    if (objFlash) objFlash.cleanup();
});