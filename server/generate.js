module.exports = {
    generate: function() {
      var area = [];
      var items = {};
      items.rocks = [];
      var width = 60;
      var height = 60;
      for (i=0;i<width;i++){
          area[i] = [];
          
          for (j=0;j<height;j++){
              
              if ((distance(i,j,width/2, height/2))<15+Math.random()*15) {
                  area[i][j] = "g";
                  if ((distance(i,j,width/2, height/2))>2+Math.random()*3 && Math.random()>0.5+(distance(i,j,width/2, height/2))/60){
                      items.rocks.push(placeItems(i+1,j+1));
                  }
              } else {
                  area[i][j] = "f";
              }
          }
      }
      var px = Math.floor(width/2)+1;
      var py = Math.floor(height/2)+1;
      items.portal = {
        x: px,
        y: py
      };
      return {items: items, area: area};
    }
  
};

function placeItems(x, y) {
    return {x: x, y: y};
}

function distance(x1, y1, x2, y2){
    var dx = x1-x2;
    var dy = y1-y2;
    return Math.sqrt(dx*dx+dy*dy);
    
}

tileTypes = ["g","w"];
