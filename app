const board = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
];
let score = 0;

const gameBoard = document.getElementById('game-board');
const scoreElement = document.getElementById('score');
const restartButton = document.getElementById('restart-button');

function init() {
    board.forEach((row, i) => {
        row.forEach((cell, j) => {
            const tile = document.createElement('div');
            tile.classList.add('tile');
            tile.id = `tile-${i}-${j}`;
            gameBoard.appendChild(tile);
        });
    });
    addRandomTile();
    addRandomTile();
    updateBoard();
}

function addRandomTile() {
    let empty = [];
    board.forEach((row, i) => {
        row.forEach((cell, j) => {
            if (cell === 0) empty.push({i, j});
        });
    });
    if (empty.length === 0) return;
    let {i, j} = empty[Math.floor(Math.random() * empty.length)];
    board[i][j] = Math.random() < 0.9 ? 2 : 4;
}

function updateBoard() {
    board.forEach((row, i) => {
        row.forEach((cell, j) => {
            const tile = document.getElementById(`tile-${i}-${j}`);
            tile.textContent = cell !== 0 ? cell : '';
            tile.style.backgroundColor = getTileColor(cell);
        });
    });
    scoreElement.textContent = score;
}

function getTileColor(value) {
    const colors = {
        0: '#cdc1b4',
        2: '#eee4da',
        4: '#ede0c8',
        8: '#f2b179',
        16: '#f59563',
        32: '#f67c5f',
        64: '#f65e3b',
        128: '#edcf72',
        256: '#edcc61',
        512: '#edc850',
        1024: '#edc53f',
        2048: '#edc22e'
    };
    return colors[value] || '#3c3a32';
}

document.addEventListener('keydown', handleInput);
restartButton.addEventListener('click', restartGame);

function handleInput(e) {
    switch(e.key) {
        case 'ArrowUp':
            moveUp();
            break;
        case 'ArrowDown':
            moveDown();
            break;
        case 'ArrowLeft':
            moveLeft();
            break;
        case 'ArrowRight':
            moveRight();
            break;
        default:
            return;
    }
    addRandomTile();
    updateBoard();
    if (isGameOver()) {
        alert('Игра окончена! Ваш счет: ' + score);
    }
}

function moveLeft() {
    for(let i=0; i<4; i++) {
        let row = board[i].filter(val => val !== 0);
        for(let j=0; j<row.length-1; j++) {
            if(row[j] === row[j+1]) {
                row[j] *= 2;
                score += row[j];
                row[j+1] = 0;
            }
        }
        row = row.filter(val => val !== 0);
        while(row.length < 4) row.push(0);
        board[i] = row;
    }
}

function moveRight() {
    for(let i=0; i<4; i++) {
        let row = board[i].filter(val => val !== 0).reverse();
        for(let j=0; j<row.length-1; j++) {
            if(row[j] === row[j+1]) {
                row[j] *= 2;
                score += row[j];
                row[j+1] = 0;
            }
        }
        row = row.filter(val => val !== 0);
        while(row.length < 4) row.push(0);
        board[i] = row.reverse();
    }
}

function moveUp() {
    for(let j=0; j<4; j++) {
        let col = [];
        for(let i=0; i<4; i++) {
            if(board[i][j] !== 0) col.push(board[i][j]);
        }
        for(let i=0; i<col.length-1; i++) {
            if(col[i] === col[i+1]) {
                col[i] *= 2;
                score += col[i];
                col[i+1] = 0;
            }
        }
        col = col.filter(val => val !== 0);
        while(col.length < 4) col.push(0);
        for(let i=0; i<4; i++) {
            board[i][j] = col[i];
        }
    }
}

function moveDown() {
    for(let j=0; j<4; j++) {
        let col = [];
        for(let i=3; i>=0; i--) {
            if(board[i][j] !== 0) col.push(board[i][j]);
        }
        for(let i=0; i<col.length-1; i++) {
            if(col[i] === col[i+1]) {
                col[i] *= 2;
                score += col[i];
                col[i+1] = 0;
            }
        }
        col = col.filter(val => val !== 0);
        while(col.length < 4) col.push(0);
        for(let i=0; i<4; i++) {
            board[3-i][j] = col[i];
        }
    }
}

function isGameOver() {
    for(let i=0; i<4; i++) {
        for(let j=0; j<4; j++) {
            if(board[i][j] === 0) return false;
            if(i < 3 && board[i][j] === board[i+1][j]) return false;
            if(j < 3 && board[i][j] === board[i][j+1]) return false;
        }
    }
    return true;
}

function restartGame() {
    for(let i=0; i<4; i++) {
        for(let j=0; j<4; j++) {
            board[i][j] = 0;
        }
    }
    score = 0;
    addRandomTile();
    addRandomTile();
    updateBoard();
}
