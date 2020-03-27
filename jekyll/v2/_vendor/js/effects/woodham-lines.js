window.woodhamLines = function () {
  "use strict";

  const canvas = document.getElementById("woodham-lines-canvas");

  if (canvas == null)
    return;
  
  const context = canvas.getContext("2d");
  const dotArray = [];
  const maxDots = 500;
  const dotRate = 2;
  const lineDistance = 75;

  const speedMin = 0.25;
  const speedMax = 1.25;

  const mousePos = {};
  const mouseDistance = 50;
  const mouseRate = 1;

  let cWidth = 0;

  let currentFrames = 0;

  /* Handle Canvas */
  function unstretch() {
    const canv = document.getElementById("woodham-lines-canvas");
    const height = canv.offsetHeight;
    const width = canv.offsetWidth;
    cWidth = width;
    canvas.setAttribute("height", height);
    canvas.setAttribute("width", width);
  }

  function getMousePos(canvas, evt) {
    const rect = canvas.getBoundingClientRect();
    return {
      x: ((evt.clientX - rect.left) / (rect.right - rect.left)) * canvas.width,
      y: ((evt.clientY - rect.top) / (rect.bottom - rect.top)) * canvas.height
    };
  }

  /* Dot Handler */
  class Dot {
    constructor(height, width) {
      this.x = -20;
      this.y = 0;
      this.size = 1;
      this.speed = 1;
      this.randomize(height, width);
    }

    //Randomise dot speed and size
    randomize(height, width) {
      const speedRange = 1.75;
      const sizeRange = 3;
      this.x = Math.floor(Math.random() * width);
      this.y = Math.floor(Math.random() * height);
      this.speed = Math.random() * speedMax + speedMin;
      //this.size = (Math.random()*sizeRange)+1;
    }

    //checks current x position vs provided canvas width
    checkDeath(width) {
      return this.x > width;
    }

    checkMouse() {
      if (checkDistance(this, mousePos, mouseDistance)) {
        const yDelt = Math.sign(mousePos.y - this.y);
        const xDelt = Math.sign(mousePos.x - this.x);
        this.y -= mouseRate * yDelt;
        this.x -= mouseRate * xDelt;
      }
    }

    //What needs to happen to make the dot move and appear
    onAnimate(ctx) {
      this.x += this.speed;
      this.checkMouse();
      ctx.beginPath();
      ctx.fillStyle = "rgba(0,0,0,1)";
      //ctx.arc(this.x,this.y,this.size,0,2*Math.PI);
      ctx.fill();
    }
  }

//Check if the maximum number of dots has been reached, if not add more inside the bounds
  function addDots(width) {
    const height = document.getElementById("woodham-lines-canvas").offsetHeight;
    if (dotArray.length < maxDots) {
      dotArray.push(new Dot(height, width));
    }
  }

//Remove any dead dots from the dotArray, must be done at one time
  function removePile(arr) {
    for (let i = 0, len = arr.length; i < len; i++) {
      dotArray.splice(arr[i], 1);
    }
  }

  function getDistance(obj1, obj2) {
    return Math.sqrt(Math.pow(obj2.x - obj1.x, 2) + Math.pow(obj2.y - obj1.y, 2));
  }

//Check distances between dots to see if they are within bounds, return boolean
  function checkDistance(obj1, obj2, maxLen) {
    const distance = getDistance(obj1, obj2);
    return distance < maxLen;
  }

  function getFillStyle(x1, x2, dist) {
    let r = 0;
    let g = 0;
    let b = 0;
    let avg = (x1 + x2) / 2;
    let wBucket = cWidth / 3;

    if (avg < wBucket) {
      r = wBucket - avg;
      g = wBucket - (wBucket - avg);
    } else if (avg > wBucket && avg < wBucket * 2) {
      g = wBucket * 2 - avg;
      b = wBucket - (wBucket * 2 - avg);
    } else {
      b = wBucket * 3 - avg;
      r = wBucket - (wBucket * 3 - avg);
    }

    return `rgba(${r}, ${g}, ${b},${(lineDistance - dist) / lineDistance})`;
  }

//function to draw the lines between close dots
  function drawLines(arr, ctx) {
    for (let i = 0, len = arr.length; i < len; i++) {
      const dist = getDistance(arr[i][0], arr[i][1]);
      ctx.beginPath();
      ctx.strokeStyle = getFillStyle(arr[i][0].x, arr[i][1].x, dist);
      ctx.moveTo(arr[i][0].x, arr[i][0].y);
      ctx.lineTo(arr[i][1].x, arr[i][1].y);
      ctx.stroke();
    }
  }

  function mousePositions(e) {
    const pos = getMousePos(canvas, e);
    mousePos.x = pos.x;
    mousePos.y = pos.y;
  }

  /* Animate Functions */
  function animate(e) {
    context.clearRect(0, 0, canvas.width, canvas.height);
    const width = context.canvas.clientWidth;
    const killPile = [];
    const linePile = [];
    currentFrames++;

    //Iterate over each Dot
    for (let i = 0, len = dotArray.length; i < len; i++) {
      if (dotArray[i].checkDeath(width)) {
        killPile.push(i);
      }
      dotArray[i].onAnimate(context);
      //Check all dots after current to see if they are close enough
      for (let j = i + 1; j < len; j++) {
        if (checkDistance(dotArray[i], dotArray[j], lineDistance)) {
          linePile.push([dotArray[i], dotArray[j]]);
        }
      }
    }

    //handle lines
    removePile(killPile);
    drawLines(linePile, context);

    //Add and remove dots at specified times
    if (currentFrames % dotRate === 0) {
      addDots(0);
    }
    window.requestAnimationFrame(animate);
  }

  window.addEventListener("resize", unstretch);

  window.addEventListener("mousemove", mousePositions);

  window.addEventListener("contextmenu", function (e) {
    e.preventDefault();
    return false;
  });

  unstretch();
  animate();

};

