using MDB.AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class SimcardMusterInfo : System.Web.UI.UserControl
    {
        public string Simnumber { get; set; }
        public Simcard Simcard { get; set; }
        public Employee Employee { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected override void OnDataBinding(EventArgs e)
        {
            base.OnDataBinding(e);
            lblSimnumber.Text = Simnumber;
            phNullSimcard.Visible = Simcard == null;
            imgWarning.Visible = Simcard == null;
            phSimcard.Visible = Simcard != null;

            if (Simcard != null)
            {
                lblNumber.Text = Simcard.Number;
                lblProvider.Text = Simcard.Provider;
                lblStatus.Text = Simcard.CurrentStatus;
            }
            else
            {
                if (Employee != null)
                {
                    List<Simcard> simcards = Simcard.FindSimcards(Employee);
                    rptOtherSimcards.DataSource = simcards;
                    rptOtherSimcards.DataBind();

                    lblOther.Visible = simcards.Count > 0;
                }

                rtxtSimnumber.ValidationGroup = this.ClientID;
                rtxtProvider.ValidationGroup = this.ClientID;
                rfvUnit.ValidationGroup = this.ClientID;
                btnCreateSimcard.ValidationGroup = this.ClientID;
            }
        }

        protected void rptOtherSimcards_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item)
            {
                Label lblSimcard = (Label)e.Item.FindControl("lblSimcard");
                lblSimcard.Attributes.Add("data-type", "correctnumber");
                lblSimcard.Attributes.Add("data-target", hdnSimnumber.ClientID);
            }
        }

        protected void btnCreateSimcard_Click(object sender, EventArgs e)
        {
            string simnumber = rtxtSimnumber.Text.Trim();

            if (simnumber != "")
            {
                SimcardWithResult s = (SimcardWithResult)Simcard.GetSimcard(simnumber);

                if (s == null)
                {
                    s = new SimcardWithResult
                    {
                        Simnumber = simnumber,
                        PUK = "",
                        Number = txtNumber.Text,
                        IsData = false,//Ikke implementeret
                        FormatId = 0,
                        QuotaId = 1,//Ikke implementeret
                        DataPlanId = 1,//Ikke implementeret
                        Provider = rtxtProvider.Text,
                        UnitId = int.Parse(ddlUnit.SelectedValue),
                        OrderNumber = "",
                        Notes = $"Oprettet under mønstring {DateTime.Today.ToString("yyyyMMdd")}"
                    };

                    if (s.Save())
                    {
                        s.Result = "Oprettet";
                        phCreate.Visible = false;
                        imgWarning.Visible = false;
                        lblWarning.Visible = false;
                        rptOtherSimcards.Visible = false;
                        lblSimnumber.Text = simnumber;
                        hdnSimnumber.Value = simnumber;
                    }
                    else
                        s.Result = "Noget gik galt";
                }
                else
                    s.Result = "Findes i forvejen";

                lblCreateMsg.Text = s.Result;
                lblCreateMsg.Visible = true;
            }
        }
    }
}