<%@ Page Title="Opret flere mobile enheder" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="multideviceinsert.aspx.cs" Inherits="MDB.multideviceinsert" %>
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
                <asp:Label Text="Tryk på [ENTER] i IMEI-feltet for at gå til næste IMEI-felt (for at man kan skanne stregkoder)." runat="server" />
                <asp:Label Text="Kun linjer hvor IMEI er udfyldt vil blive oprettet." runat="server" />
            </div>
        </div>
        <asp:TextBox runat="server" max='<%# maxLines %>' ID="txtNumberOfRows" CssClass="left" TextMode="Number" />
        <asp:Button Text="Generer linjer" CssClass="left" CausesValidation="false" OnClick="btnGenerateLines_Click" ID="btnGenerateLines" runat="server" />
        <input type="button" value="Fyld alle fra første linje" id="btnFillAll" onclick="FillAll()" class="right" />
    </div>
    <asp:GridView ID="gvDevices" CssClass="gridview" runat="server" OnRowDataBound="gvDevices_RowDataBound" AutoGenerateColumns="False">
        <Columns>
            <asp:TemplateField HeaderText="IMEI*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtIMEI" MaxLength="50" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Model*">
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtModel" MaxLength="50" />
                    <ajaxToolkit:AutoCompleteExtender ID="aceModel" runat="server" ServiceMethod="GetModels" TargetControlID="txtModel" />
                    <asp:CustomValidator ID="cvModel" runat="server" ErrorMessage="Du skal vælge en model" ValidateEmptyText="true" ControlToValidate="txtModel" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" />
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
            <asp:TemplateField HeaderText="Type*">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlType" runat="server" DataSourceID="sdsType" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                        <asp:ListItem Selected="True" Value="">-Vælg type-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:CustomValidator ID="cvType" ErrorMessage="Du skal vælge en type" ValidateEmptyText="true" ControlToValidate="ddlType" ClientValidationFunction="ValidateMultiInsertCell" OnServerValidate="cv_ServerValidate" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Units]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [DeviceTypes]"></asp:SqlDataSource>
    <asp:Button Text="Opret" ID="btnInsert" OnClick="btnInsert_Click" runat="server" />
    <asp:GridView runat="server" ID="gvResult" CssClass="gridview list" AutoGenerateColumns="false" OnRowDataBound="gvResult_RowDataBound">
        <Columns>
            <asp:BoundField HeaderText="Id" DataField="Id" />
            <asp:BoundField HeaderText="IMEI" DataField="IMEI" />
            <asp:BoundField HeaderText="Resultat" DataField="Result" />
            <asp:BoundField HeaderText="Model" DataField="Model" />
            <asp:BoundField HeaderText="Provider" DataField="Provider" />
            <asp:BoundField HeaderText="MYN" DataField="Unit" />
            <asp:BoundField HeaderText="Type" DataField="Type" />
        </Columns>
    </asp:GridView>
</asp:Content>