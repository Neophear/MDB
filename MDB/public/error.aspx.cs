﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Public
{
	public partial class error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string errorCode = Request.QueryString["e"] ?? "";

            switch (errorCode)
            {
                case "404":
                    SetMessage("Siden blev ikke fundet!");
                    break;
                case "notexist":
                    SetMessage("Objektet eksisterer ikke");
                    break;
                default:
                    SetMessage("Der skete en ukendt fejl. Prøv igen, og kontakt IT hvis fejlen gentager sig.");
                    break;
            }
        }
        protected void SetMessage(string message)
        {
            lblErrorMessage.Text = message;
        }
    }
}