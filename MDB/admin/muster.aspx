<%@ Page Title="Mønstring" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="muster.aspx.cs" Inherits="MDB.admin.muster" %>
<%@ Register Src="~/Controls/TextBoxWithOptions.ascx" TagPrefix="uc1" TagName="TextBoxWithOptions" %>
<%@ Register Src="~/Controls/DeviceMusterInfo.ascx" TagPrefix="uc1" TagName="DeviceMusterInfo" %>
<%@ Register Src="~/Controls/SimcardMusterInfo.ascx" TagPrefix="uc1" TagName="SimcardMusterInfo" %>
<%@ Import Namespace="MDB.AppCode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="musterTop">
        <div class="infobox">
            <div>
                <img src="/Content/images/icon_info.png" class="icon" />
            </div>
            <div>
                <asp:Label Text="Kun linjer hvor enten IMEI eller SIM-nummer er udfyldt, vil blive kørt." runat="server" />
            </div>
        </div>
        <asp:Label ID="lblMusterMsg" runat="server" Visible="false" Font-Bold="true"></asp:Label>
        <asp:Label ID="lblMusterInfo" runat="server">
            Upload udfyldt regneark.
        </asp:Label>
        <br />
        <asp:FileUpload ID="fuFile" runat="server" />
        <asp:RequiredFieldValidator ID="rfvFile" runat="server" ErrorMessage="Du skal vælge en fil." ValidationGroup="Upload" ControlToValidate="fuFile" Text="*" CssClass="error" ToolTip="Du skal vælge en fil."></asp:RequiredFieldValidator>
        <asp:Button ID="btnUpload" runat="server" Text="Upload" ValidationGroup="Upload" OnClick="btnUpload_Click" />
        <asp:CheckBox ID="chkbxStorageIfEmptyMANR" runat="server" Text="Sæt på lager ved tomt MANR" />
    </div>
    <asp:GridView ID="gvInput" CssClass="gridview" runat="server" OnRowDataBound="gvInput_RowDataBound" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Line" HeaderText="#" ReadOnly="true" />
            <asp:TemplateField HeaderText="MANR">
                <ItemTemplate>
                    <uc1:TextBoxWithOptions runat="server" id="tbwoMANR" LinePart='<%# Eval("MANR") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Stabsnummer">
                <ItemTemplate>
                    <uc1:TextBoxWithOptions runat="server" id="tbwoStabsnummer" PreferInput="true" LinePart='<%# Eval("Stabsnummer") %>' />
                    <asp:CustomValidator ID="cvStabsnummer" runat="server" ValidationGroup="muster" ErrorMessage="Du skal skrive et stabsnummer" ValidateEmptyText="true" ControlToValidate="tbwoStabsnummer:txt" ClientValidationFunction="ValidateMusterCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Navn">
                <ItemTemplate>
                    <uc1:TextBoxWithOptions runat="server" id="tbwoName" LinePart='<%# Eval("Name") %>' />
                    <asp:CustomValidator ID="cvName" runat="server" ValidationGroup="muster" ErrorMessage="Du skal skrive et navn" ValidateEmptyText="true" ControlToValidate="tbwoName:txt" ClientValidationFunction="ValidateMusterCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Mobil enhed">
                <ItemTemplate>
                    <uc1:DeviceMusterInfo runat="server" ID="dhiDevice" Employee='<%# Eval("Employee") %>' Visible='<%# Eval("IMEI").ToString() != "" %>' IMEI='<%# Eval("IMEI") %>' Device='<%# Eval("Device") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="SIM-kort">
                <ItemTemplate>
                    <uc1:SimcardMusterInfo runat="server" ID="shiSimcard" Employee='<%# Eval("Employee") %>' Visible='<%# Eval("Simnumber").ToString() != "" %>' Simnumber='<%# Eval("Simnumber") %>' Simcard='<%# Eval("Simcard") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Beskatning">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlTaxType" runat="server" AppendDataBoundItems="true" DataSourceID="sdsTaxType" DataTextField="Name" DataValueField="Id">
                        <asp:ListItem Value="">-Vælg beskatning-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="sdsTaxType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [TaxTypes]"></asp:SqlDataSource>
                    <asp:CustomValidator ID="cvTaxType" runat="server" ValidationGroup="muster" ErrorMessage="Du skal angive en beskatning" ValidateEmptyText="true" ControlToValidate="ddlTaxType" ClientValidationFunction="ValidateMusterCell" OnServerValidate="cv_ServerValidate" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Button ID="btnInsertMuster" runat="server" ValidationGroup="muster" Visible="false" CssClass="right" Text="Kør mønstring" OnClick="btnInsertMuster_Click" />
    <asp:TextBox ID="txtResult" TextMode="MultiLine" runat="server" Visible="false" />
</asp:Content>