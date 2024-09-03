$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'open':
                $("#earthShop").show();
                if (event.data.cars) {
                    loadCars(event.data.cars);
                }
                break;
            case 'close':
                $("#earthShop").hide();
                break;
            case 'loadCars':
                loadCars(event.data.cars);
                break;
        }
    }, false);

    $(document).on('click', '.exit-btn', function() {
        $.post('https://earthVehicleShop/close');
    });

    $(document).on('click', '.buy-btn', function() {
        var model = $(this).closest('.car-card').data('model');
        $.post('https://earthVehicleShop/kupiVozilo', JSON.stringify({ model: model }));
        $.post('https://earthVehicleShop/zatvori', JSON.stringify({}));
    });

    $(document).on('click', '.test-drive-btn', function() {
        var model = $(this).closest('.car-card').data('model');
        $.post('https://earthVehicleShop/pokreniTestVoznju', JSON.stringify({ model: model }));
        $.post('https://earthVehicleShop/zatvori', JSON.stringify({}));
    });
});

function loadCars(cars) {
    const carGrid = document.getElementById('car-grid');
    carGrid.innerHTML = '';

    cars.forEach(car => {
        const carCard = document.createElement('div');
        carCard.className = `car-card ${car.category}`;
        carCard.setAttribute('data-model', car.model);

        carCard.innerHTML = `
            <img src="${car.image}" alt="${car.name}" class="car-image">
            <h3>${car.name}</h3>
            <p class="price">Price: $${car.price}</p>
            <div class="car-info">
                <p><i class="fas fa-tachometer-alt"></i> <strong>Max speed:</strong> ${car.maxSpeed}</p>
                <p><i class="fas fa-suitcase"></i> <strong>Trunk Storage:</strong> ${car.trunkCapacity}</p>
                <p><i class="fas fa-gas-pump"></i> <strong>Fuel:</strong> ${car.fuelConsumption}</p>
            </div>
            <div class="button-group">
                <button class="buy-btn"><i class="fas fa-shopping-cart"></i> Buy</button>
                <button class="test-drive-btn"><i class="fas fa-road"></i> Test Drive</button>
            </div>
        `;

        carGrid.appendChild(carCard);
    });

    filterCars('all');
}

function filterCars(category) {
    const cars = document.querySelectorAll('.car-card');

    cars.forEach(car => {
        if (category === 'all' || car.classList.contains(category)) {
            car.classList.add('active');
        } else {
            car.classList.remove('active');
        }
    });
}

window.onload = function() {
    $.post('https://earthVehicleShop/getCars', JSON.stringify({}), function(data) {
        loadCars(data.cars);
    });
};

document.onkeyup = function(data) {
    if (data.which === 27) {
        $.post('https://earthVehicleShop/zatvori', JSON.stringify({}));
    }
}
