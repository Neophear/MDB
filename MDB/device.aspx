<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="device.aspx.cs" Inherits="MDB.device" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>
<%@ Register Assembly="MDB" Namespace="MDB.Controls" TagPrefix="MDB" %>
<%@ Register Src="~/Controls/DetailsTooltip.ascx" TagPrefix="MDB" TagName="DetailsTooltip" %>
<%@ Register Src="~/Controls/ShowLog.ascx" TagPrefix="MDB" TagName="ShowLog" %>
<%@ Register Src="~/Controls/Comments.ascx" TagPrefix="MDB" TagName="Comments" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="left">
        <asp:Label ID="lblMessage" runat="server" Text="lblMessage" Visible="false"></asp:Label>
        <asp:DetailsView ID="dvDevice" runat="server"
            CssClass="detailsview list"
            OnDataBound="dvDevice_DataBound"
            AutoGenerateRows="False"
            DataKeyNames="Id"
            DataSourceID="sdsDevice"
            OnItemInserting="dvDevice_ItemInserting"
            OnItemUpdating="dvDevice_ItemUpdating"
            OnItemUpdated="dvDevice_ItemUpdated">
            <Fields>
                <asp:BoundField DataField="Id" Visible="false" HeaderText="Id" ReadOnly="True" SortExpression="Id" />
                <asp:TemplateField HeaderText="IMEI" SortExpression="IMEI">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtIMEI" CheckIfExists="Device" MinLength="1" MaxLength="50" PropertyText="IMEI" Text='<%# Bind("IMEI") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtIMEI" CheckIfExists="Device" MinLength="1" MaxLength="50" PropertyText="IMEI" Text='<%# Bind("IMEI") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblIMEI" runat="server" Text='<%# Bind("IMEI") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Model" SortExpression="Model">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtModel" MinLength="1" MaxLength="50" ServiceMethod="GetModels" PropertyText="Model" Text='<%# Bind("Model") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtModel" MinLength="1" MaxLength="50" ServiceMethod="GetModels" PropertyText="Model" Text='<%# Bind("Model") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblModel" runat="server" Text='<%# Bind("Model") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Leverandør" SortExpression="Provider">
                    <EditItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtProvider" MinLength="1" MaxLength="50" ServiceMethod="GetProviders" PropertyText="Udbyder" Text='<%# Bind("Provider") %>' />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <MDB:ReqTextBox runat="server" ID="rtxtProvider" MinLength="1" MaxLength="50" ServiceMethod="GetProviders" PropertyText="Udbyder" Text='<%# Bind("Provider") %>' />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblProvider" runat="server" Text='<%# Bind("Provider") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Bestillingsnummer" ConvertEmptyStringToNull="false" SortExpression="OrderNumber">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtOrderNumber" runat="server" Text='<%# Bind("OrderNumber") %>' MaxLength="50"></asp:TextBox>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:TextBox ID="txtOrderNumber" runat="server" Text='<%# Bind("OrderNumber") %>' MaxLength="50"></asp:TextBox>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblOrderNumber" runat="server" Text='<%# Bind("OrderNumber") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Købsdato" SortExpression="BuyDate">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtBuyDate" runat="server" Text='<%# Bind("BuyDate", "{0:dd-MM-yyyy}") %>'></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revBuyDate" ControlToValidate="txtBuyDate" ValidationExpression="^([0-2]\d|3[01])-(0\d|1[0-2])-(19|20)(\d{2})$" runat="server" ErrorMessage="Købsdato er i forkert format (dd-mm-yyyy)"></asp:RegularExpressionValidator>
                        <ajaxToolkit:CalendarExtender ID="ceBuyDate" TargetControlID="txtBuyDate" Format="dd-MM-yyyy" runat="server" />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:TextBox ID="txtBuyDate" runat="server" ReadOnly="true" Text='<%# Bind("BuyDate", "{0:dd-MM-yyyy}") %>'></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revBuyDate" ControlToValidate="txtBuyDate" ValidationExpression="^([0-2]\d|3[01])-(0\d|1[0-2])-(19|20)(\d{2})$" runat="server" ErrorMessage="Købsdato er i forkert format (dd-mm-yyyy)"></asp:RegularExpressionValidator>
                        <ajaxToolkit:CalendarExtender ID="ceBuyDate" TargetControlID="txtBuyDate" Format="dd-MM-yyyy" runat="server" />
                        <%--<script type="text/javascript">
                            function changeTodayText(sender, args) {
                                var $div = document.getElementById('cphMain_dvDevice_ceBuyDate_today');
                                $div.innerHTML = $div.innerHTML.replace('Today', 'I dag');
                            }
                        </script>--%>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblBuyDate" runat="server" Text='<%# Bind("BuyDate", "{0:dd-MM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="MYN" SortExpression="Unit">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlUnit" runat="server" DataSourceID="sdsUnit" DataTextField="Name" DataValueField="Id"></asp:DropDownList>
                        <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Units]"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:DropDownList ID="ddlUnit" runat="server" DataSourceID="sdsUnit" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                            <asp:ListItem Selected="True" Value="">-Vælg MYN-</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Units]"></asp:SqlDataSource>
                        <asp:RequiredFieldValidator ID="rfvUnit" runat="server" ControlToValidate="ddlUnit" ErrorMessage="Du skal vælge en myndighed"></asp:RequiredFieldValidator>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblUnit" runat="server" Text='<%# Bind("Unit") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Type" SortExpression="TypeRefId">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlType" runat="server" DataSourceID="sdsType" DataTextField="Name" DataValueField="Id"></asp:DropDownList>
                        <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [DeviceTypes]"></asp:SqlDataSource>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:DropDownList ID="ddlType" runat="server" DataSourceID="sdsType" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                            <asp:ListItem Selected="True" Value="">-Vælg type-</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [DeviceTypes]"></asp:SqlDataSource>
                        <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="ddlType" ErrorMessage="Du skal vælge en type"></asp:RequiredFieldValidator>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblType" runat="server" Text='<%# Bind("Type") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Noter" ConvertEmptyStringToNull="false" SortExpression="Notes">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" Text='<%# Bind("Notes") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblNotes" runat="server" Text='<%# Eval("Notes").ToString().Replace("\n", "<br>") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" InsertVisible="false" SortExpression="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                        <asp:HyperLink ID="hplEmployee" Font-Bold="true" Visible='<%# Eval("EmployeeId") != DBNull.Value %>' NavigateUrl='<%# $"~/employee/{Eval("EmployeeId")}" %>' runat="server"><%# $"{Eval("Stabsnummer")} {Eval("Name")}" %></asp:HyperLink>
                        <asp:Label ID="lblTaxType" runat="server" Text='<%# Eval("TaxType") %>'></asp:Label>
                        <asp:Label ID="lblNotApproved" Visible='<%# Eval("OrderApproved") != null && !(bool)Eval("OrderApproved") %>' runat="server" CssClass="error block" Text="Ikke bekræftet i ny stilling!"></asp:Label>
                        <asp:Panel ID="pnlStatusInsertOrder" Visible='<%# MDB.AppCode.Globals.CanUserWrite() %>' runat="server">
                            <asp:LinkButton ID="lnkbtnInsertOrder" runat="server">Skift status</asp:LinkButton>
                            <ajaxToolkit:ModalPopupExtender BehaviorID="mpe" ID="mpeInsertOrder" BackgroundCssClass="modalBackground" TargetControlID="lnkbtnInsertOrder" PopupControlID="pnlInsertOrder" runat="server"></ajaxToolkit:ModalPopupExtender>
                            <asp:LinkButton ID="lnkbtnStatusStorage" OnClick="lnkbtnStatusStorage_Click" Visible='<%# (string)Eval("Status") != "Lager" %>' runat="server">Lager</asp:LinkButton>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <InsertItemTemplate>
                        <asp:LinkButton ID="lnkbtnInsert" runat="server" CausesValidation="True" CommandName="Insert" Text="Opret"></asp:LinkButton>
                    </InsertItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="lnkbtnUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Gem"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Annuller"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbtnEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Rediger"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Fields>
        </asp:DetailsView>
        <asp:ValidationSummary ID="vsChange" CssClass="valsum" runat="server" />
        <asp:SqlDataSource ID="sdsDevice" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="SELECT * FROM [DeviceView] WHERE ([Id] = @Id)"
            OnInserting="sdsDevice_Changing" OnUpdating="sdsDevice_Changing" OnDeleting="sdsDevice_Changing"
            OnInserted="sdsDevice_Inserted" OnDeleted="sdsDevice_Deleted"
            InsertCommand="DeviceInsert" InsertCommandType="StoredProcedure"
            UpdateCommand="DeviceUpdate" UpdateCommandType="StoredProcedure"
            DeleteCommand="DeviceDelete" DeleteCommandType="StoredProcedure">
            <SelectParameters>
                <asp:RouteParameter Name="Id" RouteKey="Id" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="Executor" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="IMEI" Type="String" />
                <asp:Parameter Name="Model" Type="String" />
                <asp:Parameter Name="Provider" Type="String" />
                <asp:Parameter Name="OrderNumber" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="BuyDate" Type="DateTime" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="UnitRefId" Type="Int32" />
                <asp:Parameter Name="TypeRefId" Type="Int32" />
                <asp:Parameter Name="Notes" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Executor" Type="String" />
                <asp:Parameter Name="LastId" Type="Int32" Direction="Output" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="IMEI" Type="String" />
                <asp:Parameter Name="Model" Type="String" />
                <asp:Parameter Name="Provider" Type="String" />
                <asp:Parameter Name="OrderNumber" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="BuyDate" Type="DateTime" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="UnitRefId" Type="Int32" />
                <asp:Parameter Name="TypeRefId" Type="Int32" />
                <asp:Parameter Name="Notes" Type="String" ConvertEmptyStringToNull="false" />
                <asp:Parameter Name="Executor" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:Panel ID="pnlInsertOrder" Visible='<%# (User.IsInRole("Admin") || User.IsInRole("Write")) && dvDevice.CurrentMode == DetailsViewMode.ReadOnly %>' CssClass="modalPopup" runat="server">
            <asp:UpdatePanel ID="upInsertOrder" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnInsertOrder" />
                </Triggers>
                <ContentTemplate>
                    <script type="text/javascript">
                        document.onkeyup = Esc;
                        function Esc() {
                            if (event.keyCode == 27) { $find("mpe").hide(); }
                        }
                        function pageLoad() {
                            $find("mpe").add_shown(onShown);
                        }
                        function onShown() {
                            var background = $find("mpe")._backgroundElement;
                            background.onclick = function () { $find("mpe").hide(); }
                        }
                    </script>
                    <h3>Ny ordre</h3>
                    <asp:Table ID="tblInsertOrder" runat="server">
                        <asp:TableRow>
                            <asp:TableCell>
                                Status
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="sdsStatus" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged" DataTextField="Name" DataValueField="Id">
                                    <asp:ListItem Selected="True" Value="">-Vælg status-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sdsStatus" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Status] WHERE [ObjectTypeRefId] = 3"></asp:SqlDataSource>
                                <asp:RequiredFieldValidator ID="rfvStatus" runat="server" ValidationGroup="assign" ControlToValidate="ddlStatus" ErrorMessage="Du skal vælge en status"></asp:RequiredFieldValidator>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server" ID="trAssignedMANR" Visible="false">
                            <asp:TableCell>
                                MANR
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:TextBox ID="txtAssignedMANR" runat="server" AutoPostBack="true" OnTextChanged="txtAssignedMANR_TextChanged"></asp:TextBox>
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:RequiredFieldValidator ID="rfvAssignedEmployee" runat="server" ValidationGroup="assign" ControlToValidate="txtAssignedMANR" ErrorMessage="Du skal skrive et gyldigt MANR"></asp:RequiredFieldValidator>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server" ID="trAssignedStabsnummer" Visible="false">
                            <asp:TableCell>
                                Stabsnummer
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:TextBox ID="txtAssignedStabsnummer" runat="server" AutoPostBack="true" OnTextChanged="txtAssignedStabsnummer_TextChanged"></asp:TextBox>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server" ID="trAssignedName" Visible="false">
                            <asp:TableCell>
                                Navn
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:TextBox ID="txtAssignedName" runat="server"></asp:TextBox>
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:RequiredFieldValidator ID="rfvAssignedName" runat="server" ValidationGroup="assign" ControlToValidate="txtAssignedName" ErrorMessage="Du skal skrive et navn"></asp:RequiredFieldValidator>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow runat="server" ID="trTaxType" Visible="false">
                            <asp:TableCell>
                                Beskatning
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:DropDownList ID="ddlTaxType" runat="server" AppendDataBoundItems="true" ValidationGroup="assign" OnDataBound="ddlTaxType_DataBound" DataSourceID="sdsTaxType" DataTextField="Name" DataValueField="Id">
                                    <asp:ListItem Selected="True" Value="0">-Vælg beskatning-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sdsTaxType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [TaxTypes]"></asp:SqlDataSource>
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:RegularExpressionValidator ID="revTaxType" ControlToValidate="ddlTaxType" ValidationGroup="assign" ValidationExpression="[1-2]" runat="server" ErrorMessage="Du skal vælge en beskatning"></asp:RegularExpressionValidator>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell>
                                Noter
                            </asp:TableCell>
                            <asp:TableCell>
                                <asp:TextBox ID="txtOrderNotes" runat="server" MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow>
                            <asp:TableCell ColumnSpan="2">
                                <asp:Button ID="btnInsertOrder" CausesValidation="true" ValidationGroup="assign" OnClick="btnInsertOrder_Click" runat="server" Text="Opret ordre" />
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    </div>
    <div class="right">
        <MDB:Comments runat="server" ID="Comments" />
    </div>
    <div style="clear:both;"></div>
    <br />
    <asp:GridView ID="gvOrders" runat="server" CssClass="gridview list" AllowSorting="true" AllowPaging="true" PageSize="20" AutoGenerateColumns="False" DataSourceID="sdsOrders">
        <Columns>
            <asp:BoundField DataField="OrderId" HeaderText="Ordre" SortExpression="OrderId" />
            <asp:BoundField DataField="TimeStamp" HeaderText="Ændringsdato" DataFormatString="{0:dd-MM-yyyy}" SortExpression="TimeStamp" />
            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
            <asp:TemplateField HeaderText="Udleveret til" SortExpression="Stabsnummer">
                <ItemTemplate>
                    <asp:HyperLink ID="hplEmployee" Visible='<%# Eval("EmployeeId") != DBNull.Value %>' NavigateUrl='<%# $"~/employee/{Eval("EmployeeId")}" %>' runat="server"><%# $"{Eval("Stabsnummer")} {Eval("Name")}" %></asp:HyperLink>
                    <asp:Label ID="lblNotAssigned" runat="server" Text="Ingen" Visible='<%# Eval("EmployeeId") == DBNull.Value %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="TaxType" HeaderText="Beskatning" SortExpression="TaxType" />
            <asp:TemplateField HeaderText="Note" SortExpression="Notes">
                <ItemTemplate>
                    <MDB:DetailsTooltip runat="server" ID="DetailsTooltip" Text='<%# Bind("Notes") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsOrders" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [OrdersView] WHERE (([ObjectTypeRefId] = 3) AND ([ObjectRefId] = @ObjectRefId)) ORDER BY [TimeStamp] DESC">
        <SelectParameters>
            <asp:RouteParameter Name="ObjectRefId" RouteKey="Id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <MDB:ShowLog runat="server" ID="ShowLog" />
</asp:Content>