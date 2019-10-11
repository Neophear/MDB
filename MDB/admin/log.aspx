<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="log.aspx.cs" Inherits="MDB.admin.log" %>
<%@ Register Src="~/Controls/DetailsTooltip.ascx" TagPrefix="MDB" TagName="DetailsTooltip" %>
<%@ Register Src="~/Controls/HoverDetails.ascx" TagPrefix="MDB" TagName="HoverDetails" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblError" runat="server" Text="lblError" Visible="false" CssClass="error" /><br />
    <asp:CompareValidator ID="cvDateFrom" runat="server" CssClass="error" ErrorMessage="Ikke en valid Fra-dato" ControlToValidate="txtDateFrom" Operator="DataTypeCheck" SetFocusOnError="True" Type="Date" Text="Ikke en valid Fra-dato" Display="Dynamic" />
    <asp:CompareValidator ID="cvDateTo" runat="server" ErrorMessage="Ikke en valid Til-dato" ControlToValidate="txtDateTo" CssClass="error" Operator="DataTypeCheck" Display="Dynamic" SetFocusOnError="True" Type="Date" Text="Ikke en valid Til-dato" />
    <asp:CheckBox ID="chkbxWithDates" Checked="true" runat="server" data-type="showhidedates" Text="Med datoer" /><br />
    <asp:TextBox ID="txtDateFrom" runat="server" TextMode="Date" data-type="date" MaxLength="50" />
    <asp:TextBox ID="txtDateTo" runat="server" TextMode="Date" data-type="date" MaxLength="50" />
    <asp:TextBox ID="txtSearchTerm" placeholder="Søgetekst" runat="server" Height="21" />
    <asp:CheckBox ID="chkbxOnlyCurrentUser" runat="server" Text="Kun mine" Checked="false" />
    <asp:Button ID="btnLoadLog" runat="server" Text="Hent log" OnClick="btnLoadLog_Click" />
    <br /><br />
    <asp:GridView ID="gvLog" runat="server" CssClass="list gridview" AutoGenerateColumns="False" OnRowDataBound="gvLog_RowDataBound" AllowSorting="True" DataSourceID="sdsLog">
        <Columns>
            <asp:BoundField DataField="TimeStamp" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Tidspunkt" SortExpression="TimeStamp" />
            <asp:BoundField DataField="Action" HeaderText="Handling" SortExpression="Action" />
            <asp:BoundField DataField="ObjectType" HeaderText="Genstand" SortExpression="ObjectType" />
            <asp:BoundField DataField="ObjectId" HeaderText="GenstandsID" SortExpression="ObjectId" />
            <asp:TemplateField HeaderText="Properties" SortExpression="Properties">
                <ItemTemplate>
                    <MDB:HoverDetails runat="server" Text='<%# Stiig.Utilities.CutText(Eval("Properties").ToString(), "...", 30, false) %>'
                        TextFull='<%# Eval("Properties") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Values" SortExpression="Values">
                <ItemTemplate>
                    <MDB:HoverDetails runat="server" Text='<%# Stiig.Utilities.CutText(Eval("Values").ToString(), "...", 60, false) %>'
                        TextFull='<%# Eval("Values") %>' id="HoverDetails" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Udfører" SortExpression="Executor">
                <ItemTemplate>
                    <MDB:HoverDetails runat="server" Text='<%# Eval("ExecutorShort") %>' TextFull='<%# Eval("ExecutorFull") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" CancelSelectOnNullParameter="false" SelectCommandType="StoredProcedure" SelectCommand="GetLog">
        <SelectParameters>
            <asp:Parameter DbType="Date" Name="DateFrom" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="Date" Name="DateTo" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="String" Name="Executor" DefaultValue="" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="String" Name="SearchTerm" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>