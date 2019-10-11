<%@ Page Title="Opret flere sim-kort" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="multisimcardinsert.aspx.cs" Inherits="MDB.multisimcardinsert" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <script type="text/javascript">
        var maxLines = <%= maxLines %>;

        $(document).ready(function () {
            RunMultiInsertPageLoad();
        });
    </script>
    <div class="multiInsertTop">
        <div class="infobox">
            <div>
                <img src="/Content/images/icon_info.png" class="icon" />
            </div>
            <div>
                <asp:Label ID="lblMaxLines" runat="server" />
                <asp:Label Text="Brug [PAGEUP] eller [PAGEDOWN] til at fylde en kolonne op eller ned." runat="server" />
                <asp:Label Text="Tryk på [ENTER] i SIMnummer-feltet for at gå til næste SIMnummer-felt (for at man kan skanne stregkoder)." runat="server" />
                <asp:Label Text="Kun linjer hvor SIMnummer er udfyldt vil blive oprettet." runat="server" />
            </div>
        </div>
        <asp:TextBox runat="server" max='<%# maxLines %>' ID="txtNumberOfRows" CssClass="left" TextMode="Number" />
        <asp:Button Text="Generer linjer" CssClass="left" CausesValidation="false" OnClick="btnGenerateLines_Click" ID="btnGenerateLines" runat="server" />
        <input type="button" value="Fyld alle fra første linje" id="btnFillAll" onclick="FillAll()" class="right" />
    </div>
    <asp:GridView ID="gvSimcards" CssClass="gridview" runat="server" OnRowDataBound="gvSimcards_RowDataBound" AutoGenerateColumns="False">
        <Columns>
            <asp:TemplateField HeaderText="SIMnummer*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtSimnumber" MaxLength="50" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PUK*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtPUK" MaxLength="8" />
                    <asp:CustomValidator ID="cvPUK" runat="server" ErrorMessage="Du skal indtaste en PUK-kode" ValidateEmptyText="true" ControlToValidate="txtPUK" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Nummer">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtNumber" MaxLength="8" />
                </ItemTemplate>
            </asp:TemplateField>
<%--            <asp:TemplateField HeaderText="Type">
                <ItemTemplate>
                    <asp:RadioButtonList ID="rblIsData" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                        <asp:ListItem Value="False" Selected="True">Tale</asp:ListItem>
                        <asp:ListItem Value="True">Data</asp:ListItem>
                    </asp:RadioButtonList>
                    ---------------------MANGLER VALIDERING---------------
                </ItemTemplate>
            </asp:TemplateField>--%>
            <asp:TemplateField HeaderText="Format">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlFormat" runat="server" DataSourceID="sdsFormat" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Udbyder*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtProvider" MaxLength="50" />
                    <ajaxToolkit:AutoCompleteExtender ID="aceProvider" runat="server" ServiceMethod="GetProviders" TargetControlID="txtProvider" />
                    <asp:CustomValidator ID="cvProvider" runat="server" ErrorMessage="Du skal vælge en udbyder" ValidateEmptyText="true" ControlToValidate="txtProvider" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Bestillingsnummer">
                <ItemTemplate>
                    <asp:TextBox ID="txtOrderNumber" MaxLength="50" runat="server"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Købsdato">
                <ItemTemplate>
                    <asp:TextBox ID="txtBuyDate" runat="server" ReadOnly="true"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revBuyDate" ControlToValidate="txtBuyDate" ValidationExpression="^([0-2]\d|3[01])-(0\d|1[0-2])-(19|20)(\d{2})$" runat="server" ErrorMessage="Købsdato er i forkert format (dd-mm-yyyy)"></asp:RegularExpressionValidator>
                    <ajaxToolkit:CalendarExtender ID="ceBuyDate" TargetControlID="txtBuyDate" Format="dd-MM-yyyy" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="MYN*">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlUnit" runat="server" DataSourceID="sdsUnit" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                        <asp:ListItem Selected="True" Value="">-Vælg MYN-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:CustomValidator ID="cvUnit" ErrorMessage="Du skal vælge en MYN" ValidateEmptyText="true" ControlToValidate="ddlUnit" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsFormat" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [SimcardFormats]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsQuota" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Quotas]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDataPlan" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [DataPlans]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Units]"></asp:SqlDataSource>
    <asp:Button Text="Opret" ID="btnInsert" OnClick="btnInsert_Click" runat="server" />
    <asp:GridView runat="server" ID="gvResult" CssClass="gridview list" AutoGenerateColumns="false" OnRowDataBound="gvResult_RowDataBound">
        <Columns>
            <asp:BoundField HeaderText="Id" DataField="Id" />
            <asp:BoundField HeaderText="SIMnummer" DataField="Simnumber" />
            <asp:BoundField HeaderText="Resultat" DataField="Result" />
            <asp:BoundField HeaderText="PUK" DataField="PUK" />
            <asp:BoundField HeaderText="Nummer" DataField="Number" />
            <asp:BoundField HeaderText="Provider" DataField="Provider" />
            <asp:BoundField HeaderText="MYN" DataField="Unit" />
        </Columns>
    </asp:GridView>
</asp:Content>