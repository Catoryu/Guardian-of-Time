using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CtyLib.Logs;

namespace GuardianOfTime
{
    public partial class ListForm : Form
    {
        //Declaring the list
        private List<Character> Characters;
        private LogWriter Logs;
        private List<string> ListChoices;

        /// <summary>
        /// Initialize ListForm.
        /// </summary>
        /// <param name="ListOfCharacters">List of all characters</param>
        /// <param name="Logs">Log Writer</param>
        public ListForm(List<Character> ListOfCharacters, LogWriter Logs)
        {
            try
            {
                Logs.Debug("Initializing ListForm...");
                InitializeComponent();
                this.Characters = ListOfCharacters;
                this.Logs = Logs;
                Logs.Debug("ListForm : OK.");

                Logs.Debug("Preparing ListChoices...");
                ListChoices = new List<string>();
                ListChoices.Add("Last Name");
                ListChoices.Add("First Name");
                ListChoices.Add("Hair Color");
                ListChoices.Add("Hair Length");
                ListChoices.Add("Eyes Color");
                ListChoices.Add("Race");
                ListChoices.Add("Height");
                ListChoices.Add("Birth Date");
                ListChoices.Add("Timeline");
                ListChoices.Add("Elements");
                ListChoices.Add("Powers");
                ListChoices.Add("Likes");
                ListChoices.Add("Unlikes");
                ListChoices.Add("Activities");
                ListChoices.Add("Backstory");
                ListChoices.Add("Weapons");
                ListChoices.Add("Alternative");

                foreach (string value in ListChoices)
                {
                    ChoiceBox1.Items.Add(value);
                    ChoiceBox2.Items.Add(value);
                    ChoiceBox3.Items.Add(value);
                    ChoiceBox4.Items.Add(value);
                }

                ListTable.Columns.Add("", 200, HorizontalAlignment.Left);
                ListTable.Columns.Add("", 200, HorizontalAlignment.Left);
                ListTable.Columns.Add("", 200, HorizontalAlignment.Left);
                ListTable.Columns.Add("", 200, HorizontalAlignment.Left);

                foreach (Character value in Characters)
                {
                    ListViewItem item = new ListViewItem();
                    item.Text = "";
                    item.SubItems.Add("");
                    item.SubItems.Add("");
                    item.SubItems.Add("");
                    ListTable.Items.Add(item);
                }
                Logs.Debug("Choices and Lists prepared.");
            }
            catch (Exception ex)
            {
                Logs.Error(ex);
            }
            
        }

        /// <summary>
        /// ChoiceBox1 Select
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ChoiceBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Logs.Debug("ChoiceBox1 Changed.");
                if (ChoiceBox1.SelectedIndex != -1)
                {
                    int i = 0;
                    ListTable.Columns[0].Text = ChoiceBox1.SelectedItem.ToString();
                    switch (ChoiceBox1.SelectedItem.ToString())
                    {
                        case "Last Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.LastName.Name;
                                i++;
                            }
                            break;
                        case "First Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.FirstName;
                                i++;
                            }
                            break;
                        case "Hair Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.Hair.Color;
                                i++;
                            }
                            break;
                        case "Hair Length":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.Hair.Length;
                                i++;
                            }
                            break;
                        case "Eyes Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.EyesColor;
                                i++;
                            }
                            break;
                        case "Race":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.Race.Name;
                                i++;
                            }
                            break;
                        case "Height":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.Height.ToString();
                                i++;
                            }
                            break;
                        case "Birth Date":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.Birth.Day.ToString() + "/" + value.Birth.Month.ToString() + "/" + value.Birth.Year.ToString();
                                i++;
                            }
                            break;
                        case "Timeline":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[0].Text = value.TimeLine.Name;
                                i++;
                            }
                            break;
                        case "Elements":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (string val in value.Elements)
                                {
                                    text += val + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Powers":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Power val in value.Powers)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Likes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Likes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Unlikes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Unlikes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Activities":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Activity val in value.Activities)
                                {
                                    text += val.Title + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Backstory":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (BackStory val in value.Backstory)
                                {
                                    text += val.Story;
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Weapons":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Weapon val in value.Weapons)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[0].Text = text;
                                i++;
                            }
                            break;
                        case "Alternative":
                            foreach (Character value in Characters)
                            {
                                if (value.Alternative != null)
                                {
                                    ListTable.Items[i].SubItems[0].Text = value.Alternative.TimeLine.Name + " -> " + value.TimeLine.Name;
                                }
                                else
                                {
                                    ListTable.Items[i].SubItems[0].Text = "";
                                }
                                i++;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            catch(Exception ex)
            {
                Logs.Error(ex);
            }
        }

        /// <summary>
        /// ChoiceBox2 Select
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ChoiceBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Logs.Debug("ChoiceBox2 Changed.");
                if (ChoiceBox2.SelectedIndex != -1)
                {
                    int i = 0;
                    ListTable.Columns[1].Text = ChoiceBox2.SelectedItem.ToString();
                    switch (ChoiceBox2.SelectedItem.ToString())
                    {
                        case "Last Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.LastName.Name;
                                i++;
                            }
                            break;
                        case "First Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.FirstName;
                                i++;
                            }
                            break;
                        case "Hair Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.Hair.Color;
                                i++;
                            }
                            break;
                        case "Hair Length":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.Hair.Length;
                                i++;
                            }
                            break;
                        case "Eyes Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.EyesColor;
                                i++;
                            }
                            break;
                        case "Race":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.Race.Name;
                                i++;
                            }
                            break;
                        case "Height":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.Height.ToString();
                                i++;
                            }
                            break;
                        case "Birth Date":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.Birth.Day.ToString() + "/" + value.Birth.Month.ToString() + "/" + value.Birth.Year.ToString();
                                i++;
                            }
                            break;
                        case "Timeline":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[1].Text = value.TimeLine.Name;
                                i++;
                            }
                            break;
                        case "Elements":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (string val in value.Elements)
                                {
                                    text += val + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Powers":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Power val in value.Powers)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Likes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Likes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Unlikes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Unlikes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Activities":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Activity val in value.Activities)
                                {
                                    text += val.Title + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Backstory":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (BackStory val in value.Backstory)
                                {
                                    text += val.Story;
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Weapons":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Weapon val in value.Weapons)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[1].Text = text;
                                i++;
                            }
                            break;
                        case "Alternative":
                            foreach (Character value in Characters)
                            {
                                if (value.Alternative != null)
                                {
                                    ListTable.Items[i].SubItems[1].Text = value.Alternative.TimeLine.Name + " -> " + value.TimeLine.Name;
                                }
                                else
                                {
                                    ListTable.Items[i].SubItems[1].Text = "";
                                }
                                i++;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            catch(Exception ex)
            {
                Logs.Error(ex);
            }
        }

        /// <summary>
        /// ChoiceBox3 Select
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ChoiceBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Logs.Debug("ChoiceBox3 Changed.");
                if (ChoiceBox3.SelectedIndex != -1)
                {
                    int i = 0;
                    ListTable.Columns[2].Text = ChoiceBox3.SelectedItem.ToString();
                    switch (ChoiceBox3.SelectedItem.ToString())
                    {
                        case "Last Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.LastName.Name;
                                i++;
                            }
                            break;
                        case "First Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.FirstName;
                                i++;
                            }
                            break;
                        case "Hair Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.Hair.Color;
                                i++;
                            }
                            break;
                        case "Hair Length":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.Hair.Length;
                                i++;
                            }
                            break;
                        case "Eyes Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.EyesColor;
                                i++;
                            }
                            break;
                        case "Race":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.Race.Name;
                                i++;
                            }
                            break;
                        case "Height":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.Height.ToString();
                                i++;
                            }
                            break;
                        case "Birth Date":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.Birth.Day.ToString() + "/" + value.Birth.Month.ToString() + "/" + value.Birth.Year.ToString();
                                i++;
                            }
                            break;
                        case "Timeline":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[2].Text = value.TimeLine.Name;
                                i++;
                            }
                            break;
                        case "Elements":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (string val in value.Elements)
                                {
                                    text += val + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Powers":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Power val in value.Powers)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Likes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Likes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Unlikes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Unlikes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Activities":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Activity val in value.Activities)
                                {
                                    text += val.Title + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Backstory":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (BackStory val in value.Backstory)
                                {
                                    text += val.Story;
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Weapons":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Weapon val in value.Weapons)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[2].Text = text;
                                i++;
                            }
                            break;
                        case "Alternative":
                            foreach (Character value in Characters)
                            {
                                if (value.Alternative != null)
                                {
                                    ListTable.Items[i].SubItems[2].Text = value.Alternative.TimeLine.Name + " -> " + value.TimeLine.Name;
                                }
                                else
                                {
                                    ListTable.Items[i].SubItems[2].Text = "";
                                }
                                i++;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            catch(Exception ex)
            {
                Logs.Error(ex);
            }
        }

        /// <summary>
        /// ChoiceBox4 Select
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ChoiceBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Logs.Debug("ChoiceBox4 Changed.");
                if (ChoiceBox4.SelectedIndex != -1)
                {
                    int i = 0;
                    ListTable.Columns[3].Text = ChoiceBox4.SelectedItem.ToString();
                    switch (ChoiceBox4.SelectedItem.ToString())
                    {
                        case "Last Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.LastName.Name;
                                i++;
                            }
                            break;
                        case "First Name":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.FirstName;
                                i++;
                            }
                            break;
                        case "Hair Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.Hair.Color;
                                i++;
                            }
                            break;
                        case "Hair Length":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.Hair.Length;
                                i++;
                            }
                            break;
                        case "Eyes Color":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.EyesColor;
                                i++;
                            }
                            break;
                        case "Race":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.Race.Name;
                                i++;
                            }
                            break;
                        case "Height":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.Height.ToString();
                                i++;
                            }
                            break;
                        case "Birth Date":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.Birth.Day.ToString() + "/" + value.Birth.Month.ToString() + "/" + value.Birth.Year.ToString();
                                i++;
                            }
                            break;
                        case "Timeline":
                            foreach (Character value in Characters)
                            {
                                ListTable.Items[i].SubItems[3].Text = value.TimeLine.Name;
                                i++;
                            }
                            break;
                        case "Elements":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (string val in value.Elements)
                                {
                                    text += val + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Powers":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Power val in value.Powers)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Likes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Likes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Unlikes":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Thing val in value.Unlikes)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Activities":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Activity val in value.Activities)
                                {
                                    text += val.Title + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Backstory":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (BackStory val in value.Backstory)
                                {
                                    text += val.Story;
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Weapons":
                            foreach (Character value in Characters)
                            {
                                string text = "";
                                foreach (Weapon val in value.Weapons)
                                {
                                    text += val.Name + " - ";
                                }
                                ListTable.Items[i].SubItems[3].Text = text;
                                i++;
                            }
                            break;
                        case "Alternative":
                            foreach (Character value in Characters)
                            {
                                if (value.Alternative != null)
                                {
                                    ListTable.Items[i].SubItems[3].Text = value.Alternative.TimeLine.Name + " -> " + value.TimeLine.Name;
                                }
                                else
                                {
                                    ListTable.Items[i].SubItems[3].Text = "";
                                }
                                i++;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                Logs.Error(ex);
            }
        }
    }
}
