<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="userlog.aspx.cs" Inherits="MDB.admin.userlog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblError" runat="server" Text="lblError" Visible="false" CssClass="error"></asp:Label><br />
    <asp:CompareValidator ID="cvDateFrom" runat="server" CssClass="error" ErrorMessage="Ikke en valid Fra-dato" ControlToValidate="txtDateFrom" Operator="DataTypeCheck" SetFocusOnError="True" Type="Date" Text="Ikke en valid Fra-dato" Display="Dynamic"></asp:CompareValidator>
    <asp:CompareValidator ID="cvDateTo" runat="server" ErrorMessage="Ikke en valid Til-dato" ControlToValidate="txtDateTo" CssClass="error" Operator="DataTypeCheck" Display="Dynamic" SetFocusOnError="True" Type="Date" Text="Ikke en valid Til-dato"></asp:CompareValidator>
    <%--<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>--%>
    <script type="text/javascript">
        $(document).ready(function(){
            ShowHideDates();
        });
        function ShowHideDates() {
            var chkbxWithDates = document.getElementById('<%= chkbxWithDates.ClientID %>');
            var txtDateFrom = document.getElementById('<%= txtDateFrom.ClientID %>');
            var txtDateTo = document.getElementById('<%= txtDateTo.ClientID %>');

            txtDateFrom.hidden = !chkbxWithDates.checked;
            txtDateTo.hidden = !chkbxWithDates.checked;
        }
    </script>
    <asp:CheckBox ID="chkbxWithDates" Checked="true" runat="server" onclick="ShowHideDates()" Text="Med datoer" /><br />
    <asp:TextBox ID="txtDateFrom" runat="server" TextMode="Date" MaxLength="50"></asp:TextBox>
    <asp:TextBox ID="txtDateTo" runat="server" TextMode="Date" MaxLength="50"></asp:TextBox>
    <asp:TextBox ID="txtSearchTerm" placeholder="Søgetekst" runat="server" Height="21"></asp:TextBox>
    <asp:CheckBox ID="chkbxOnlyCurrentUser" runat="server" Text="Kun mine" Checked="false" />
    <asp:Button ID="btnLoadLog" runat="server" Text="Hent log" OnClick="btnLoadLog_Click" />
    <br /><br />
    <asp:GridView ID="gvLog" runat="server" CssClass="list gridview" AutoGenerateColumns="False" AllowSorting="True" DataSourceID="sdsLog">
        <Columns>
            <asp:BoundField DataField="TimeStamp" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Tidspunkt" SortExpression="TimeStamp" />
            <asp:BoundField DataField="Action" HeaderText="Handling" SortExpression="Action" />
            <asp:TemplateField HeaderText="Udfører" SortExpression="Executor">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# Eval("Executor") %>' ToolTip='<%# Eval("ExecutorFullname") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="AffectedUsername" HeaderText="Bruger" SortExpression="AffectedUsername" />
            <asp:BoundField DataField="AffectedFullname" HeaderText="Navn" SortExpression="AffectedFullname" />
            <asp:BoundField DataField="Properties" HeaderText="Egenskaber" SortExpression="Properties" />
            <asp:BoundField DataField="Values" HeaderText="Værdier" SortExpression="Values" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" CancelSelectOnNullParameter="false" SelectCommandType="StoredProcedure" SelectCommand="GetUserLog">
        <SelectParameters>
            <asp:Parameter DbType="Date" Name="DateFrom" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="Date" Name="DateTo" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="String" Name="Executor" DefaultValue="" ConvertEmptyStringToNull="true" />
            <asp:Parameter DbType="String" Name="SearchTerm" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>