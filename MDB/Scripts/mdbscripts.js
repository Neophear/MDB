$(function () {
    $("[data-type=showhidedates]").children("input").click(function () {
        if (this.checked) {
            $("[data-type=date]").show();
        }
        else {
            $("[data-type=date]").hide();
        }
    });

    $(".textwithoptions [data-type=insert]").click(function (event) {
        var txt = $(event.target).parent().prev();
        $(txt).val($(event.target).text());
        $(txt).removeClass("warning");
    });

    $("[data-type=correctnumber]").click(function (event) {
        var target = document.getElementById($(event.target).attr("data-target"));
        $(target).val($(event.target).text());
        $(target).prev().text($(event.target).text());
        $(target).next("img").hide();
    });
});

var _txtbx;
function ShowAvailability(txt, type, allowEmpty) {
    if (typeof allowEmpty === 'undefined') { allowEmpty = false; }
    _txtbx = txt;
    if (txt.value === '') {
        if (allowEmpty) {
            SetTargetStatus(txt, ValidateStatus.None);
        } else {
            SetTargetStatus(txt, ValidateStatus.Error);
        }
    }
    else if (txt.defaultValue === txt.value) {
        SetTargetStatus(txt, ValidateStatus.Success);
    }
    else {
        MDB.WebService.Exists(txt.value, type, OnSuccess);
    }
}
function OnSuccess(response) {
    $(_txtbx).removeClass();

    if (response) { SetTargetStatus(_txtbx, ValidateStatus.Error); }
    else { SetTargetStatus(_txtbx, ValidateStatus.Success); }
}

function NavigateTo(event,location) {
    if (event.button === 1 || event.ctrlKey) {
        window.open(location);
    }else if (event.button === 0) {
        window.location = location;
    }
}

function ValidateNotEmpty(sender, e) {
    var targetControl = $("#" + $(sender).attr("data-val-controltovalidate"));
    e.IsValid = e.Value !== "";

    if (e.IsValid) {
        SetTargetStatus(targetControl, ValidateStatus.None);
    } else {
        SetTargetStatus(targetControl, ValidateStatus.Error);
    }
}

function FillAll() {
    var firstRow = $("[data-type=fill][data-row-index=1]");
    for (var i = 0; i < firstRow.length; i++) {
        var col = $(firstRow[i]).attr("data-col");
        var value = $(firstRow[i]).val();
        $("[data-col=" + col + "]").val(value);
    }
}

function SetTargetStatus(target, status) {
    $(target).removeClass("error success warning");
    if (status === ValidateStatus.Success) {
        $(target).addClass("success");
    } else if (status === ValidateStatus.Error) {
        $(target).addClass("error");
    } else if (status === ValidateStatus.Warning) {
        $(target).addClass("warning");
    }
}

var ValidateStatus = {
    None: 0,
    Error: 1,
    Success: 2,
    Warning: 3
};

function ValidateMultiInsertCell(sender, e) {
    var targetControl = $("#" + $(sender).attr("data-val-controltovalidate"));
    var identifier = $("[data-type=identifier][data-row-index=" + $(targetControl).attr("data-row-index") + "]");
    e.IsValid = ($(identifier).val() === "" || e.Value !== "");
    
    if (e.IsValid) {
        SetTargetStatus(targetControl, ValidateStatus.None);
    } else {
        SetTargetStatus(targetControl, ValidateStatus.Error);
    }
}

function RunMultiInsertPageLoad() {
    $("[data-row-index]").on("keydown", function (event) {
        if (event.which === 33 || event.which === 34) {
            if ($(this).attr("data-type") === "fill") {
                var colindex = $(this).parent().index();
                var table = $(this).closest("table")[0];

                var value = $(this).is("span") ? this.children[0].checked : this.value;
                var thisRowIndex = $(this).attr("data-row-index");

                var startRow = (event.which === 33) ? 1 : thisRowIndex;
                var endRow = (event.which === 34) ? table.rows.length : thisRowIndex;
                for (var i = startRow; i < endRow; i++) {
                    var element = table.rows[i].cells[colindex].children[0];

                    if ($(element).is("span"))
                        element.children[0].checked = value;
                    else
                        element.value = value;
                }
            }
            
            return false;
        }
    });

    $("[data-type=identifier]").on("keydown", function (event) {
        if (event.which === 13) {
            var nextRowIndex = parseInt($(this).attr("data-row-index")) + 1;
            var nextRow = $("[data-type=identifier][data-row-index=" + nextRowIndex + "]");
            if (nextRow !== null) {
                $(nextRow).focus();
            }
            return false;
        }
    });

    $("[data-type=identifier]").on("blur", function (event) {
        if ($(this).val() === "") {
            SetTargetStatus($("[data-type=fill][data-row-index=" + $(this).attr("data-row-index") + "]"), ValidateStatus.None);
        }
    });

    var prevValue;

    $(".multiInsertTop input[type=number]").on("keypress", function (event) {
        if (!/\d/.test(event.key)) {
            event.preventDefault();
        } else {
            prevValue = $(this).val();
        }
    });

    $(".multiInsertTop input[type=number]").on("input", function (event) {
        if ($(this).val().length > 0) {
            var newValue = parseInt($(this).val());
            if (isNaN(newValue)) {
                $(this).val(prevValue);
            }
            else if (newValue < 0) {
                $(this).val(0);
            }
            else if (newValue > maxLines) {
                $(this).val(maxLines);
            }
        }
    });

    $(".multiInsertTop input[type=number]").on("blur", function (event) {
        if ($(this).val() < 1) {
            $(this).val(1);
        }
    });
}

function ValidateMusterCell(sender, e) {
    var targetControl = $("#" + $(sender).attr("data-val-controltovalidate"));
    var identifier = $("[data-type=identifier][data-row-index=" + $(targetControl).attr("data-row-index") + "]");
    e.IsValid = ($(identifier).val() === "" || e.Value !== "");

    if (e.IsValid) {
        SetTargetStatus(targetControl, ValidateStatus.None);
    } else {
        SetTargetStatus(targetControl, ValidateStatus.Error);
    }
}

function MusterCheckSubject(sender) {
    var row = $(sender).attr("data-row-index");
    var isEmpty = $(sender).val() === "";
    
    $("[data-row-index=" + row + "]:not([data-type=identifier])").each(function () {
        if (!isEmpty && $(this).val() === "")
            SetTargetStatus(this, ValidateStatus.Error);
        else
            SetTargetStatus(this, ValidateStatus.None);
    });
}