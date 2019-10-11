<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdvancedTextBox.ascx.cs" Inherits="MDB.Controls.AdvancedTextBox" %>

<script type="text/javascript">
    function wrapSelection(sender, wrapperLeft, wrapperRight)
    {
        var txtText = document.forms[0].<%= txtText.ClientID %>;

        var selectStart = txtText.selectionStart;
        var selectEnd = txtText.selectionEnd;
        var firstText = txtText.value.substring(0, selectStart);
        var selectedText = txtText.value.substring(selectStart, selectEnd);
        var lastText = txtText.value.substring(selectEnd, txtText.value.length);

        txtText.value = firstText + wrapperLeft + selectedText + wrapperRight + lastText;

        txtText.selectionStart = selectStart + wrapperLeft.length;
        txtText.selectionEnd = selectEnd + wrapperLeft.length;

        if (sender.tagName == "SELECT") {
            sender.selectedIndex = 0;
        }
    }

    //Helpbox messages
    bold_help = "Fed tekst: [b]tekst[/b]";
    italic_help = "Kursiv tekst: [i]tekst[/i]";
    underline_help = "Understreget tekst: [u]tekst[/u]";
    strikethrough_help = "Gennemstreget tekst: [s]tekst[/s]";
    img_help = "Indsæt billede: [img]http://billede_url[/img]";
    url_help = "Indsæt link: [url]http://url[/url] eller [url=http://url]Link navn[/url]";
    fontcolor_help = "Tekst farve: [color=red]tekst[/color]  Tip: Du kan også bruge [color=#FF0000]";
    fontsize_help = "Tekst størrelse: [size=6]lille tekst[/size]";
    reset_help = "Nulstil teksten";

    // Shows the help messages in the helpline window
    function helpline(help)
    {
        var helpbox = document.getElementById('<%= txtHelpbox.ClientID %>');
        helpbox.value = eval(help + "_help");
    }
    function ResetEditor_onclick()
    {
        var txtText = document.forms[0].<%= txtText.ClientID %>;

        if(confirm("Feltet vil blive nulstillet til som det var før.\nEr du sikker?")) {
            txtText.value = txtText.defaultValue;
        }
    }
</script>

<table class="editorTable">
    <tr>
        <td>
            <%-- Buttons --%>
            <input type="button" value="Fed" name="bold" onclick="javascript: wrapSelection(this, '[b]', '[/b]');" onmouseover="helpline('bold')" />
            <input type="button" value="Kursiv" name="italic" onclick="javascript: wrapSelection(this, '[i]', '[/i]');" onmouseover="helpline('italic')" />
            <input type="button" value="Understreget" name="underline" onclick="javascript: wrapSelection(this, '[u]', '[/u]');" onmouseover="helpline('underline')" />
            <input type="button" value="Gennemstreget" name="strikethrough" onclick="javascript: wrapSelection(this, '[s]', '[/s]');" onmouseover="helpline('strikethrough')" />
            <input type="button" value="Url" name="url" onclick="javascript: wrapSelection(this, '[url]http://', '[/url]');" onmouseover="helpline('url')" />
            <input type="button" value="Billede" name="img" onclick="javascript: wrapSelection(this, '[img]', '[/img]');" onmouseover="helpline('img')" />
            <select name="fontsize" onchange="wrapSelection(this, '[size=' + this.form.fontsize.options[this.form.fontsize.selectedIndex].value + ']', '[/size]');"
                onmouseover="helpline('fontsize')">
                <option value="">-Størrelse-</option>
                <option value="8">Meget lille</option>
                <option value="10">Lille</option>
                <option value="12">Normal</option>
                <option value="14">Stor</option>
                <option value="16">Meget stor</option>
            </select>
            <select name="fontcolor" onchange="wrapSelection(this, '[color=' + this.form.fontcolor.options[this.form.fontcolor.selectedIndex].value + ']', '[/color]');"
                onmouseover="helpline('fontcolor')" class="editorButton">
                <option value="">-Farve-</option>
                <option value="black" style="color: black;">Sort</option>
                <option value="silver" style="color: silver;">Sølv</option>
                <option value="gray" style="color: gray;">Grå</option>
                <option value="maroon" style="color: maroon;">Maroon</option>
                <option value="red" style="color: red;">Rød</option>
                <option value="purple" style="color: purple;">Lilla</option>
                <option value="fuchsia" style="color: fuchsia;">Lyserød</option>
                <option value="navy" style="color: navy;">Navy</option>
                <option value="blue" style="color: blue;">Blå</option>
                <option value="aqua" style="color: aqua;">Aqua</option>
                <option value="teal" style="color: teal;">Teal</option>
                <option value="lime" style="color: lime;">Lime</option>
                <option value="green" style="color: green;">Grøn</option>
                <option value="olive" style="color: olive;">Oliven</option>
                <option value="yellow" style="color: yellow;">Gul</option>
                <option value="white" style="color: white;">Hvid</option>
            </select>
            <input type="button" onclick="javascript: ResetEditor_onclick();" onmouseover="helpline('reset')" value="Nulstil" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:TextBox ID="txtHelpbox" ReadOnly="true" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:TextBox ID="txtText" TextMode="MultiLine" Rows="10" Columns="58" runat="server"></asp:TextBox>
        </td>
    </tr>
</table>