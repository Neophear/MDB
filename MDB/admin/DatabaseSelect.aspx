<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DatabaseSelect.aspx.cs" Inherits="MDB.admin.DatabaseSelect" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblMessage" runat="server" CssClass="error" Text="lblMessage" Visible="false" />
<%--    <asp:DropDownList ID="ddlPresets" runat="server" AppendDataBoundItems="true" DataValueField="Id" DataTextField="Name" DataSourceID="sdsPresets" AutoPostBack="True">
        <asp:ListItem Value="" Text="-Vælg preset-" />
    </asp:DropDownList>
    <asp:DetailsView ID="dvPreset" runat="server" DataSourceID="sdsPreset" AutoGenerateRows="False" DataKeyNames="Id">
        <Fields>
            <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
            <asp:BoundField DataField="Value" HeaderText="Value" SortExpression="Value" />
        </Fields>
    </asp:DetailsView>
    <asp:SqlDataSource ID="sdsPreset" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [SQLPresets] WHERE ([Id] = @Id)"
        InsertCommand="SQLPresetInsert" InsertCommandType="StoredProcedure"
        UpdateCommand="SQLPresetUpdate" UpdateCommandType="StoredProcedure"
        DeleteCommand="SQLPresetDelete" DeleteCommandType="StoredProcedure">
        <DeleteParameters>
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Executor" Type="String" />
            <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Value" Type="String" />
            <asp:Parameter Name="Executor" Type="String" />
            <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlPresets" Name="Id" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Value" Type="String" />
            <asp:Parameter Name="Id" Type="Int32" />
            <asp:Parameter Name="Executor" Type="String" />
            <asp:Parameter Name="Result" Type="Int16" Direction="Output" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPresets" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [SQLPresets]" />--%>
    <asp:TextBox ID="txtQuery" TextMode="MultiLine" placeholder="SELECT * FROM [Devices]" runat="server" />
    <asp:Button ID="btnRun" OnClick="btnRun_Click" runat="server" Text="Kør" />
    <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Visible="false" Text="Download CSV" /><br /><br />
    <asp:GridView ID="gvResult" OnDataBound="gvResult_DataBound" AllowSorting="true" OnSorting="gvResult_Sorting" CssClass="gridview list" runat="server"></asp:GridView>
</asp:Content>