const closingTimeSeconds = 5;

function apiUrl(request) {
    return `http://localhost:3000/api/v1/${request}`;
}

function checkErrors() {
    if ($("#calculator input.is-invalid").length > 0) {
        $("#calculatorError").slideDown();
        $("#calculateBtn").attr("disabled", "disabled");
    } else {
        $("#calculatorError").slideUp();
        $("#calculateBtn").removeAttr("disabled");
    }
}

$(document).ready(() => {
    let interval;
    let calculator = $('#calculator');

    $("#calculator input").change((e) => {
        let input = $(e.target);

        if (isNaN(input.val()) || input.val().trim().length === 0) {
            input.addClass("is-invalid");
        } else {
            input.removeClass("is-invalid");
        }

        $("#calculatorNotFoundError").slideUp();
        checkErrors();
    });

    $("#launchCalculatorBtn").click(() => {
        $("#result").fadeOut();
    });

    $("#calculateBtn").click(() => {
        $("#calculator input").each((index, value) => {
            let input = $(value);

            if (isNaN(input.val()) || input.val().trim().length === 0) {
                input.addClass("is-invalid");
            } else {
                input.removeClass("is-invalid");
            }

            checkErrors();
        });

        if ($("#calculator input.is-invalid").length === 0) {
            $.getJSON(apiUrl("products/find-best-fit"),
                {
                    length: $("#calculatorLengthInput").val(),
                    width: $("#calculatorWidthInput").val(),
                    height: $("#calculatorHeightInput").val(),
                    weight: $("#calculatorWeightInput").val()
                },
                (data) => {
                    let calculateBtn = $("#calculateBtn");
                    let countdown = closingTimeSeconds;

                    interval = setInterval(() => {
                        if (countdown > 0) {
                            $("#calculateBtn").text(`Closing in ${countdown--}s`);
                        } else {
                            clearInterval(interval);
                            $("#calculator").modal('hide');
                        }
                    }, 1000);

                    let productName = `${data.product_type.name} - ${data.name} (${data.length}"x${data.width}"x${data.height}"@${data.weight}lbs)`;

                    $("#productNameModal").text(productName);
                    $("#productName").text(productName);
                    $("#length").text($("#calculatorLengthInput").val() || 0);
                    $("#width").text($("#calculatorWidthInput").val() || 0);
                    $("#height").text($("#calculatorHeightInput").val() || 0);
                    $("#weight").text($("#calculatorWeightInput").val() || 0);
                    $("#resultModal").slideDown();

                    calculateBtn.attr("disabled", "disabled");
                    calculateBtn.text(`Closing in ${countdown--}s`);
                }).fail((jqXHR) => {
                if (jqXHR.status === 404) {
                    $("#calculatorNotFoundError").slideDown();
                } else {
                    console.log(jqXHR);
                }
            });
        }
    });

    calculator.on('hidden.bs.modal', () => {
        let calculateBtn = $("#calculateBtn");

        $("#calculator input").each((index, value) => {
            let input = $(value);

            input.val("");
            input.removeClass("is-invalid")
        });
        $("#resultModal").slideUp(0);
        $("#calculatorError").slideUp(0);
        $("#calculatorNotFoundError").slideUp(0);
        calculateBtn.removeAttr("disabled");
        calculateBtn.text("Calculate");
        clearInterval(interval);
    });

    calculator.on('hide.bs.modal', () => {
        if ($("#productName").text().trim().length > 0) {
            $("#result").fadeIn();
        }
    });
});
