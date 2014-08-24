function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}

// Generate a pseudo-GUID by concatenating random hexadecimal.
function guid() {
    return (S4()+S4()+S4()+S4());
}

module.exports = {
    generate: function() {
        var area = [];
        var items = {};
        var cols = colors();
        var baseheat = Math.random()*40;
        var extraheat = Math.random()*(120-baseheat);
        var magic = {
            extraheat: extraheat,
            baseheat: baseheat
        };
        items.movables = [];
        var width = 120;
        var height = 120;
        for (i=0;i<width;i++){
          area[i] = [];
          
          for (j=0;j<height;j++){
              
              if ((distance(i,j,width/2, height/2))<30+Math.random()*30) {
                  area[i][j] = grass();
                  if ((distance(i,j,width/2, height/2))>5+Math.random()*10 && Math.random()>0.7+(distance(i,j,width/2, height/2))/(width)){
                      items.movables.push(placeItems(i+0.5+Math.random()*0.5,j+0.5+Math.random()*0.5));
                  }
              } else {
                  area[i][j] = falloff();
              }
          }
        }
        var px = Math.floor(width/2)+1;
        var py = Math.floor(height/2)+1;
        items.portal = {
        x: px,
        y: py
        };
        return {items: items, area: area, colors: cols, magic: magic};
    }
  
};

function placeItems(x, y) {
    if (Math.random()>0.05){
        return rock(x, y);
    } else {
        return torch(x, y);
    }
}

function rock(x, y){
    return {x: x, y: y, item: "rock", variant: "_0"+(Math.ceil(Math.random()*4)),  id: guid()};
}
function torch(x, y){
    return {x: x, y: y, item: "torch", id: guid()};
}

function grass() {
    return {tile: "g", "variant": "_0"+(Math.ceil(Math.random()*4))};
}

function falloff() {
    return {tile: "f", "variant": "_0"+(Math.ceil(Math.random()*4))};
}
function colors() {
    cols = [];
    var greys = Math.floor(Math.random()*10);
    for (i=0; i<greys; i++)
    {
        cols.push([i / greys + Math.random() / greys, i / greys + Math.random() / greys, i / greys + Math.random() / greys, 1])
    }
    var others = 31-greys;
    for (i=0; i<others; i++) {
        cols.push([Math.random(), Math.random(), Math.random(), 1]);
    }
    return cols;
}

function distance(x1, y1, x2, y2){
    var dx = x1-x2;
    var dy = y1-y2;
    return Math.sqrt(dx*dx+dy*dy);
    
}

tileTypes = ["g","w"];
