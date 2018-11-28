using System;
using System.Collections.Generic;
using System.Windows.Forms;
using CtyLib.Logs;//LogWriter by Catoryu
using CtyLib.Files;//FileImporter by Catoryu

namespace GuardianOfTime
{
    public partial class MainForm : Form
    {
        //LogWriter
        private LogWriter LW = new LogWriter();
        private BinarySerializer SB = new BinarySerializer();

        //Initializing the world
        private World W = new World();
        private List<Timeline> TLs = new List<Timeline>();
        private List<Activity> Acts = new List<Activity>();
        private List<Weapon> Weapons = new List<Weapon>();
        private List<Race> Races = new List<Race>();
        private List<LastName> NdF = new List<LastName>();
        private List<string> EC = new List<string>();
        private List<Hair> HairList = new List<Hair>();
        private List<Thing> Things = new List<Thing>();
        private List<Power> Powers = new List<Power>();
        private List<Character> CharaList = new List<Character>();

        //Random
        private Random Rnd = new Random();

        /// <summary>
        /// Initialize MainForm.
        /// </summary>
        public MainForm()
        {
            LW.Create(@"C:\logCS");
            try
            {
                LW.Debug("Initializing MainForm...");
                InitializeComponent();
                LW.Debug("MainForm : OK.");
                LW.Debug("Initializing World Lists...");
                #region Timelines
                TLs.Add(new Timeline("Originelle", new TimeDate(16100, 1, 1)));//2512o, 16100MK
                TLs.Add(new Timeline("MK-0/MK-2", new TimeDate(15638, 1, 1)));//2050o, 15638MK
                TLs.Add(new Timeline("MK-1", new TimeDate(260, 1, 1)));//-13588o, 260MK
                #endregion Timelines
                #region Activities/Titles
                //Originelle
                Acts.Add(new Activity("6th Dragon Council", TLs[0]));
                Acts.Add(new Activity("9th Dragon Council", TLs[0]));
                Acts.Add(new Activity("Demon Lord", TLs[0]));
                Acts.Add(new Activity("Fire God", TLs[0]));
                Acts.Add(new Activity("Ice God", TLs[0]));
                Acts.Add(new Activity("Water God", TLs[0]));
                Acts.Add(new Activity("Earth God", TLs[0]));
                Acts.Add(new Activity("Wind God", TLs[0]));
                Acts.Add(new Activity("Thunder God", TLs[0]));
                Acts.Add(new Activity("Light God", TLs[0]));
                Acts.Add(new Activity("Drakness God", TLs[0]));
                Acts.Add(new Activity("Blacksmith", TLs[0]));
                //MK-0|MK-2
                Acts.Add(new Activity("1st Dragon Council", TLs[1]));
                Acts.Add(new Activity("2nd Dragon Council", TLs[1]));
                Acts.Add(new Activity("3rd Dragon Council", TLs[1]));
                Acts.Add(new Activity("4th Dragon Council until 2047o", TLs[1]));
                Acts.Add(new Activity("4th Dragon Council", TLs[1]));
                Acts.Add(new Activity("5th Dragon Council", TLs[1]));
                Acts.Add(new Activity("6th Dragon Council", TLs[1]));
                Acts.Add(new Activity("7th Dragon Council", TLs[1]));
                Acts.Add(new Activity("8th Dragon Council", TLs[1]));
                Acts.Add(new Activity("9th Dragon Council", TLs[1]));
                Acts.Add(new Activity("10th Dragon Council", TLs[1]));
                Acts.Add(new Activity("Magic School Director", TLs[1]));
                Acts.Add(new Activity("Magic School 3rd Year Professor", TLs[1]));
                Acts.Add(new Activity("Magic School 2nd Year Professor", TLs[1]));
                Acts.Add(new Activity("Magic School 1st Year Professor", TLs[1]));
                Acts.Add(new Activity("SRP Leader", TLs[1]));
                Acts.Add(new Activity("Temp SRP Leader", TLs[1]));
                Acts.Add(new Activity("SRP Dragon Leader", TLs[1]));
                Acts.Add(new Activity("SRP Beast Leader", TLs[1]));
                Acts.Add(new Activity("SRP Beast Sub-Leader", TLs[1]));
                Acts.Add(new Activity("SRP Beast Sub-Leader 2", TLs[1]));
                Acts.Add(new Activity("SRP Vampire Leader", TLs[1]));
                Acts.Add(new Activity("SRP Vampire Sub-Leader", TLs[1]));
                Acts.Add(new Activity("SRP Vampire Sub-Leader 2", TLs[1]));
                Acts.Add(new Activity("SRP Vampire Sub-Leader 3", TLs[1]));
                Acts.Add(new Activity("SRP Human Leader", TLs[1]));
                Acts.Add(new Activity("SRP Human Sub-Leader", TLs[1]));
                Acts.Add(new Activity("SRP Human Sub-Leader 2", TLs[1]));
                Acts.Add(new Activity("SENH Leader", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader 2", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader 3", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader 4", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader 5", TLs[1]));
                Acts.Add(new Activity("SENH Sub-Leader 6", TLs[1]));
                //MK-1
                Acts.Add(new Activity("1st Dragon Council", TLs[2]));
                Acts.Add(new Activity("2nd Dragon Council", TLs[2]));
                Acts.Add(new Activity("3rd Dragon Council", TLs[2]));
                Acts.Add(new Activity("4th Dragon Council", TLs[2]));
                Acts.Add(new Activity("5th Dragon Council", TLs[2]));
                Acts.Add(new Activity("6th Dragon Council", TLs[2]));
                Acts.Add(new Activity("7th Dragon Council", TLs[2]));
                Acts.Add(new Activity("8th Dragon Council", TLs[2]));
                Acts.Add(new Activity("9th Dragon Council", TLs[2]));
                Acts.Add(new Activity("10th Dragon Council", TLs[2]));
                Acts.Add(new Activity("Fire Clan Leader", TLs[2]));
                Acts.Add(new Activity("Fire Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Ice Clan Leader until 262MK", TLs[2]));
                Acts.Add(new Activity("Ice Clan Leader", TLs[2]));
                Acts.Add(new Activity("Ice Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Water Clan Leader", TLs[2]));
                Acts.Add(new Activity("Water Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Earth Clan Leader until 265MK", TLs[2]));
                Acts.Add(new Activity("Earth Clan Leader", TLs[2]));
                Acts.Add(new Activity("Earth Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Wind Clan Leader", TLs[2]));
                Acts.Add(new Activity("Wind Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Thunder Clan Leader", TLs[2]));
                Acts.Add(new Activity("Thunder Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Light Clan Leader", TLs[2]));
                Acts.Add(new Activity("Light Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Darkness Clan Leader", TLs[2]));
                Acts.Add(new Activity("Darkness Clan Sub-Leader", TLs[2]));
                Acts.Add(new Activity("Magic School Director until 267MK", TLs[2]));
                Acts.Add(new Activity("Magic School Director", TLs[2]));
                Acts.Add(new Activity("Magic School 3rd Year Professor", TLs[2]));
                Acts.Add(new Activity("Magic School 2nd Year Professor until 260MK", TLs[2]));
                Acts.Add(new Activity("Magic School 2nd Year Professor", TLs[2]));
                Acts.Add(new Activity("Magic School 1st Year Professor", TLs[2]));
                Acts.Add(new Activity("Fire Master", TLs[2]));
                Acts.Add(new Activity("Ice Master until 260MK", TLs[2]));
                Acts.Add(new Activity("Ice Master", TLs[2]));
                Acts.Add(new Activity("Water Master", TLs[2]));
                Acts.Add(new Activity("Earth Master", TLs[2]));
                Acts.Add(new Activity("Wind Master", TLs[2]));
                Acts.Add(new Activity("Thunder Master until 268MK", TLs[2]));
                Acts.Add(new Activity("Thunder Master", TLs[2]));
                Acts.Add(new Activity("Light Master", TLs[2]));
                Acts.Add(new Activity("Darkness Master", TLs[2]));
                #endregion Activities/Titles
                #region Weapons
                //Simple Weapons
                Weapons.Add(new Weapon("Gun"));
                Weapons.Add(new Weapon("Lame"));
                Weapons.Add(new Weapon("Epée"));
                Weapons.Add(new Weapon("Katana"));
                Weapons.Add(new Weapon("Lance"));
                Weapons.Add(new Weapon("Gantelets"));
                Weapons.Add(new Weapon("Sceptre"));
                Weapons.Add(new Weapon("Dague"));
                Weapons.Add(new Weapon("Arc"));
                Weapons.Add(new Weapon("Grimoire"));
                Weapons.Add(new Weapon("Marteau"));
                Weapons.Add(new Weapon("Hache"));
                Weapons.Add(new Weapon("Eventail"));
                Weapons.Add(new Weapon("Wakizashi"));
                Weapons.Add(new Weapon("Massue"));
                Weapons.Add(new Weapon("Griffes"));
                Weapons.Add(new Weapon("Lame à deux mains"));
                Weapons.Add(new Weapon("Hache à deux mains"));
                Weapons.Add(new Weapon("Marteau à deux mains"));
                Weapons.Add(new Weapon("Chaines"));
                //Legendary Weapons
                Weapons.Add(new Weapon("Muteki", true));
                Weapons.Add(new Weapon("Doku", true));
                Weapons.Add(new Weapon("Jigoku", true));
                Weapons.Add(new Weapon("Tsukuru", true));
                Weapons.Add(new Weapon("Hangeki", true));
                Weapons.Add(new Weapon("Maho", true));
                Weapons.Add(new Weapon("Chiten", true));
                Weapons.Add(new Weapon("Spectre", true));
                Weapons.Add(new Weapon("Hokai", true));
                //Elemental Weapons
                Weapons.Add(new Weapon("Ilamas", true, W.Elements[0]));
                Weapons.Add(new Weapon("Frost Gale", true, W.Elements[1]));
                Weapons.Add(new Weapon("Sruth", true, W.Elements[2]));
                Weapons.Add(new Weapon("Pane", true, W.Elements[3]));
                Weapons.Add(new Weapon("Fengbao", true, W.Elements[4]));
                Weapons.Add(new Weapon("Tsukuyomi", true, W.Elements[5]));
                Weapons.Add(new Weapon("Solis", true, W.Elements[6]));
                Weapons.Add(new Weapon("Aloka", true, W.Elements[7]));
                #endregion Weapons
                #region Races
                Races.Add(new Race("Dragon"));
                Races.Add(new Race("Homme-bête"));
                Races.Add(new Race("Vampire"));
                Races.Add(new Race("Humain"));
                Races.Add(new Race("Démon draconnique"));
                Races.Add(new Race("Dieu élémentaire"));
                #endregion Races
                #region Eyes
                EC.Add("Bleu");
                EC.Add("Brun");
                EC.Add("Gris");
                EC.Add("Vert");
                EC.Add("Rouge");
                EC.Add("Doré");
                EC.Add("Noir");
                EC.Add("Violet");
                #endregion Eyes
                #region Hair
                HairList.Add(new Hair("Noir", "Chauve"));
                HairList.Add(new Hair("Gris", "Court"));
                HairList.Add(new Hair("Blanc", "Mi-court"));
                HairList.Add(new Hair("Blond", "Mi-long"));
                HairList.Add(new Hair("Roux", "Long"));
                HairList.Add(new Hair("Brun", "Crête"));
                #endregion Hair
                #region Things
                Things.Add(new Thing("Nourriture"));
                Things.Add(new Thing("Savoir"));
                Things.Add(new Thing("Entraînement"));
                Things.Add(new Thing("Volaille"));
                Things.Add(new Thing("Fruits"));
                Things.Add(new Thing("Les gens"));
                Things.Add(new Thing("Humains"));
                Things.Add(new Thing("Hommes-bêtes"));
                Things.Add(new Thing("Vampire"));
                Things.Add(new Thing("Nature"));
                Things.Add(new Thing("Aider les gens dans le besoin"));
                Things.Add(new Thing("Violence"));
                Things.Add(new Thing("Combat"));
                Things.Add(new Thing("Faiblesse"));
                Things.Add(new Thing("Force"));
                Things.Add(new Thing("Alcool"));
                Things.Add(new Thing("Légumes"));
                Things.Add(new Thing("Viande"));
                Things.Add(new Thing("Poisson"));
                Things.Add(new Thing("Sang"));
                Things.Add(new Thing("Complications"));
                Things.Add(new Thing("Féculants"));
                Things.Add(new Thing("Perseverance"));
                Things.Add(new Thing("Superiorité"));
                Things.Add(new Thing("Froid"));
                Things.Add(new Thing("Chaleur"));
                Things.Add(new Thing("Charité"));
                Things.Add(new Thing("Paresse"));
                Things.Add(new Thing("Espoir"));
                Things.Add(new Thing("Désespoir"));
                Things.Add(new Thing("Solitude"));
                Things.Add(new Thing("Calme"));
                Things.Add(new Thing("Bruit"));
                Things.Add(new Thing("Abandon"));
                Things.Add(new Thing("Victoire"));
                Things.Add(new Thing("Défaite"));
                Things.Add(new Thing("Vitesse"));
                Things.Add(new Thing("Ce monde"));
                Things.Add(new Thing("Soi-même"));
                Things.Add(new Thing("Amitié"));
                Things.Add(new Thing("Partage"));
                Things.Add(new Thing("Discuter"));
                Things.Add(new Thing("Ignorance"));
                Things.Add(new Thing("Société"));
                Things.Add(new Thing("Guerre"));
                Things.Add(new Thing("Paix"));
                Things.Add(new Thing("Conflits"));
                #endregion Things
                #region Powers
                Powers.Add(new Power("Propagation mentale"));
                Powers.Add(new Power("Contrôle des plantes"));
                Powers.Add(new Power("Apprentissage d'armes accéléré"));
                Powers.Add(new Power("Résurrection temporaire"));
                Powers.Add(new Power("Contrôle des vecteurs de force"));
                Powers.Add(new Power("Manipulation de décisions"));
                Powers.Add(new Power("Zone de ralentissement"));
                Powers.Add(new Power("Paralysie des membres"));
                Powers.Add(new Power("Déplacement accéléré"));
                Powers.Add(new Power("Feu divin"));
                Powers.Add(new Power("Glace divine"));
                Powers.Add(new Power("Eau divine"));
                Powers.Add(new Power("Terre divine"));
                Powers.Add(new Power("Vent divin"));
                Powers.Add(new Power("Foudre divine"));
                Powers.Add(new Power("Lumière divine"));
                Powers.Add(new Power("Ténèbres divins"));
                Powers.Add(new Power("Clonage"));
                Powers.Add(new Power("Rage"));
                Powers.Add(new Power("Déviation"));
                Powers.Add(new Power("Transmission nerveuse"));
                Powers.Add(new Power("Contrôle du sang"));
                Powers.Add(new Power("Armure rocheuse"));
                Powers.Add(new Power("Séparation de l'âme et du corps"));
                Powers.Add(new Power("Trou de ver"));
                Powers.Add(new Power("Téléportation"));
                Powers.Add(new Power("Contrôle mental"));
                Powers.Add(new Power("Télépathie"));
                Powers.Add(new Power("Zone d'accélération"));
                Powers.Add(new Power("Vision externe"));
                Powers.Add(new Power("Corps liquide"));
                Powers.Add(new Power("Corps gazeux"));
                Powers.Add(new Power("Garde imperturbable"));
                Powers.Add(new Power("Endurance illimitée"));
                Powers.Add(new Power("Métamorphose"));
                Powers.Add(new Power("Echolocation"));
                Powers.Add(new Power("Armure d'écailes"));
                Powers.Add(new Power("Clairvoyance"));
                Powers.Add(new Power("Echange d'esprit"));
                Powers.Add(new Power("Substitution spatiale"));
                Powers.Add(new Power("Augmentation de force"));
                Powers.Add(new Power("Déplacement interdimensionnel"));
                Powers.Add(new Power("Dimension personnelle"));
                Powers.Add(new Power("Illusions"));
                Powers.Add(new Power("Pulsions magnétiques"));
                Powers.Add(new Power("Répulsion"));
                Powers.Add(new Power("Attraction"));
                Powers.Add(new Power("Manipulation de souvenirs"));
                Powers.Add(new Power("Double-personnalité"));
                Powers.Add(new Power("Invisibilité"));
                Powers.Add(new Power("Manipulation de gravité"));
                Powers.Add(new Power("Psychométrie"));
                Powers.Add(new Power("Invocation d'esprits"));
                Powers.Add(new Power("Invocation de démons"));
                Powers.Add(new Power("Invocation de créatures"));
                Powers.Add(new Power("Possession d'esprits"));
                Powers.Add(new Power("Possession démoniaque"));
                Powers.Add(new Power("Perception extrasensorielle"));
                Powers.Add(new Power("Préconnaissance"));
                Powers.Add(new Power("Télékinesie"));
                Powers.Add(new Power("Rétrovision"));
                Powers.Add(new Power("Hypnose"));
                Powers.Add(new Power("Postvision"));
                Powers.Add(new Power("Contrôle de poisons"));
                Powers.Add(new Power("Manipulation de poid"));
                Powers.Add(new Power("Pensées accélérées"));
                Powers.Add(new Power("Connaissance de mensonges"));
                Powers.Add(new Power("Immunité aux maladies"));
                Powers.Add(new Power("Immunité à la fatigue"));
                Powers.Add(new Power("Immunité à la faim"));
                Powers.Add(new Power("Immunité à la soif"));
                Powers.Add(new Power("Autosuffisance"));
                Powers.Add(new Power("Corps spirituel"));
                Powers.Add(new Power("Crochetage"));
                Powers.Add(new Power("Odarat sur-développé"));
                Powers.Add(new Power("Ouïe sur-développée"));
                Powers.Add(new Power("Perception des températures"));
                Powers.Add(new Power("Transfert de mana"));
                Powers.Add(new Power("Immortalité"));
                Powers.Add(new Power("Lévitation"));
                Powers.Add(new Power("Détection d'énergie"));
                Powers.Add(new Power("Vision rayon X"));
                Powers.Add(new Power("Régéneration"));
                Powers.Add(new Power("Armure psychique"));
                Powers.Add(new Power("Soins"));
                Powers.Add(new Power("Propagation de sommeil"));
                Powers.Add(new Power("Propagation de peur"));
                Powers.Add(new Power("Perception universelle"));
                Powers.Add(new Power("Manipulation des probabilités"));
                Powers.Add(new Power("Analyse accélérée"));
                Powers.Add(new Power("Force émotionnelle"));
                Powers.Add(new Power("Augmentation de vitesse"));
                Powers.Add(new Power("Armure spirituelle"));
                Powers.Add(new Power("Contrôle des poussières"));
                Powers.Add(new Power("Armure crystallisée"));
                Powers.Add(new Power("Contrôle du bois"));
                Powers.Add(new Power("Contrôle des mineraux"));
                Powers.Add(new Power("Duplication"));
                Powers.Add(new Power("Absorption de dégats physiques"));
                Powers.Add(new Power("Immunité aux dégats physiques"));
                Powers.Add(new Power("Immunité à la douleur"));
                Powers.Add(new Power("Contrôle des gaz"));
                Powers.Add(new Power("Solidification"));
                Powers.Add(new Power("Inversion des vecteurs de force"));
                Powers.Add(new Power("Inversion de gravité"));
                Powers.Add(new Power("Vue sur-développée"));
                Powers.Add(new Power("Manipulation des sens"));
                Powers.Add(new Power("Manipulation des corps physiques"));
                Powers.Add(new Power("Suppression de souvenirs"));
                Powers.Add(new Power("Modification de souvenirs"));
                Powers.Add(new Power("Création de souvenirs"));
                Powers.Add(new Power("Inversion de probabilités"));
                Powers.Add(new Power("Attaque mentale"));
                Powers.Add(new Power("Manipulation des formes"));
                Powers.Add(new Power("Propagation de souvenirs"));
                Powers.Add(new Power("Propagation de connaissances"));
                Powers.Add(new Power("Perception de mana"));
                Powers.Add(new Power("Immunité au feu"));
                Powers.Add(new Power("Immunité à la glace"));
                Powers.Add(new Power("Immunité à l'eau"));
                Powers.Add(new Power("Immunité à la terre"));
                Powers.Add(new Power("Immunité au vent"));
                Powers.Add(new Power("Immunité à la foudre"));
                Powers.Add(new Power("Immunité à la lumière"));
                Powers.Add(new Power("Immunité aux ténèbres"));
                Powers.Add(new Power("Inversion des éléments"));
                #endregion Powers
                LW.Debug("World Lists : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }

            try
            {
                LW.Debug("Loading Boxes...");
                //Initial Load
                LoadBoxes();
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Initial load of all boxes
        /// </summary>
        private void LoadBoxes()
        {
            try
            {
                //Timelines
                LW.Debug("Loading timelines.");
                RefreshTimelines();
                //Races
                LW.Debug("Loading races.");
                RefreshRaces();
                //Names
                LW.Debug("Loading names.");
                RefreshLNames();
                RefreshFNames();
                //Elements
                LW.Debug("Loading elements.");
                RefreshElements();
                //Powers
                LW.Debug("Loading powers.");
                RefreshPowers();
                //Hair
                LW.Debug("Loading hairs.");
                RefreshHairColor();
                RefreshHairLength();
                //Eyes
                LW.Debug("Loading eyes.");
                RefreshEyesColor();
                //Things
                LW.Debug("Loading stuff.");
                RefreshLikes();
                RefreshUnlikes();
                //Activities
                LW.Debug("Loading activities.");
                RefreshActivities();
                //Weapons
                LW.Debug("Loading weapons.");
                RefreshWeapons();
                //Other
                LW.Debug("Refreshing Dates.");
                RefreshDatesLimit();
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Reset all for a new character
        /// </summary>
        private void Reset()
        {
            LW.Debug("Reseting...");
            AltCheckBox.Checked = false;
            TimelineBox.SelectedIndex = -1;
            RaceBox.SelectedIndex = -1;
            LNameBox.Enabled = true;
            FNameBox.DropDownStyle = ComboBoxStyle.DropDown;
            LNameBox.Text = "";
            FNameBox.Text = "";
            ElementBox.SelectedIndex = -1;
            ElementBox2.SelectedIndex = -1;
            PowerBox.SelectedIndex = -1;
            PowerBox2.SelectedIndex = -1;
            BirthDay.Value = 1;
            BirthMonth.Value = 1;
            BirthYear.Value = 0;
            HairColorBox.Text = "";
            HairLengthBox.Text = "";
            EyeColorBox.Text = "";
            LikeBox1.SelectedIndex = -1;
            UnlikeBox1.SelectedIndex = -1;
            LikeBox2.SelectedIndex = -1;
            UnlikeBox2.SelectedIndex = -1;
            LikeBox3.SelectedIndex = -1;
            UnlikeBox3.SelectedIndex = -1;
            LikeBox4.SelectedIndex = -1;
            UnlikeBox4.SelectedIndex = -1;
            LikeBox5.SelectedIndex = -1;
            UnlikeBox5.SelectedIndex = -1;
            ActBox1.SelectedIndex = -1;
            ActBox2.SelectedIndex = -1;
            ActBox3.SelectedIndex = -1;
            ActBox4.SelectedIndex = -1;
            BackstoryBox.Text = "";
            WeaponBox1.SelectedIndex = -1;
            WeaponBox2.SelectedIndex = -1;
            WeaponBox3.SelectedIndex = -1;
            WeaponBox4.SelectedIndex = -1;
            LoadBoxes();
        }

        #region Refresh functions
        /// <summary>
        /// Refresh the timelines boxes
        /// </summary>
        private void RefreshTimelines()
        {
            try
            {
                LW.Debug("Refreshing Timelines.");
                TimelineBox.Items.Clear();
                foreach (Timeline t in TLs)
                {
                    TimelineBox.Items.Add(t.Name);
                }
                LW.Debug("Timelines : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh the races boxes
        /// </summary>
        private void RefreshRaces()
        {
            try
            {
                LW.Debug("Refreshing Races.");
                RaceBox.Items.Clear();
                foreach (Race r in Races)
                {
                    RaceBox.Items.Add(r.Name);
                }
                LW.Debug("Races : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh last names
        /// </summary>
        private void RefreshLNames()
        {
            try
            {
                LW.Debug("Refreshing Last Names.");
                LNameBox.Items.Clear();
                if (RaceBox.SelectedIndex == -1)
                {
                    //No Race
                }
                else
                {
                    foreach (Character val in CharaList)
                    {
                        if (RaceBox.SelectedItem.ToString() == val.LastName.Race.Name)
                        {
                            if (!(LNameBox.Items.Contains(val.LastName.Name)))
                            {
                                LNameBox.Items.Add(val.LastName.Name);
                            }
                        }
                    }
                }
                LW.Debug("Last Names : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh first names
        /// </summary>
        private void RefreshFNames()
        {
            try
            {
                LW.Debug("Refreshing First Names.");
                FNameBox.Items.Clear();
                if (RaceBox.SelectedIndex != -1)
                {
                    if (RaceBox.SelectedItem.ToString() == Races[0].Name)
                    {
                        bool add;
                        LNameBox.Enabled = false;
                        FNameBox.DropDownStyle = ComboBoxStyle.DropDownList;
                        foreach (string value in W.DragonNames)
                        {
                            add = true;
                            foreach (Character val in CharaList)
                            {
                                if (val.Race.Name == Races[0].Name)
                                {
                                    if (val.FirstName == value)
                                    {
                                        add = false;
                                    }
                                }
                            }
                            if (add)
                            {
                                FNameBox.Items.Add(value);
                            }
                        }
                    }
                    else
                    {
                        LNameBox.Enabled = true;
                        FNameBox.DropDownStyle = ComboBoxStyle.DropDown;
                    }
                }
                LW.Debug("First Names : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh elements
        /// </summary>
        private void RefreshElements()
        {
            try
            {
                LW.Debug("Refreshing Elements.");
                RefreshElements1();
                RefreshElements2();
                LW.Debug("Elements : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ElementsBox
        /// </summary>
        private void RefreshElements1()
        {
            try
            {
                LW.Debug("Refreshing Element 1.");
                ElementBox.Items.Clear();
                foreach (string val in W.Elements)
                {
                    ElementBox.Items.Add(val);
                }
                LW.Debug("Element 1 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ElementsBox2
        /// </summary>
        private void RefreshElements2()
        {
            try
            {
                LW.Debug("Refreshing Element 2.");
                ElementBox2.Items.Clear();
                if (ElementBox.SelectedIndex != -1)
                {
                    foreach (string val in W.Elements)
                    {
                        if (ElementBox.SelectedItem.ToString() != val)
                        {
                            ElementBox2.Items.Add(val);
                        }
                    }
                }
                LW.Debug("Element 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh powers
        /// </summary>
        private void RefreshPowers()
        {
            try
            {
                LW.Debug("Refreshing Powers.");
                RefreshPowers1();
                RefreshPowers2();
                LW.Debug("Powers : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh PowersBox1
        /// </summary>
        private void RefreshPowers1()
        {
            try
            {
                LW.Debug("Refreshing Power 1.");
                PowerBox.Items.Clear();
                bool add;
                foreach(Power value in Powers)
                {
                    add = true;
                    foreach (Character val in CharaList)
                    {
                        if (val.Powers.Contains(value))
                        {
                            add = false;
                        }
                    }
                    if (add)
                    {
                        PowerBox.Items.Add(value.Name);
                    }
                }
                LW.Debug("Power 1 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh PowersBox2
        /// </summary>
        private void RefreshPowers2()
        {
            try
            {
                LW.Debug("Refreshing Power 2.");
                PowerBox2.Items.Clear();
                bool add;
                foreach (Power value in Powers)
                {
                    add = true;
                    foreach (Character val in CharaList)
                    {
                        if (val.Powers.Contains(value))
                        {
                            add = false;
                        }
                    }
                    if (PowerBox.SelectedIndex != -1) if (PowerBox.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        PowerBox2.Items.Add(value.Name);
                    }
                }
                LW.Debug("Power 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh birthDay limit
        /// </summary>
        private void RefreshDatesLimit()
        {
            try
            {
                LW.Debug("Refreshing Date Limits.");
                switch (BirthMonth.Value)
                {
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 12:
                        BirthDay.Maximum = 31;
                        break;
                    case 2:
                        if (BirthYear.Value % 4 == 0) BirthDay.Maximum = 29;
                        else BirthDay.Maximum = 28;
                        break;
                    case 4:
                    case 6:
                    case 9:
                    case 11:
                        BirthDay.Maximum = 30;
                        break;
                    default:
                        BirthDay.Maximum = 31;
                        break;
                }
                LW.Debug("Date Limits : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh HeightLimits
        /// </summary>
        private void RefreshHeightLimit()
        {
            try
            {
                LW.Debug("Refreshing Height Limits.");
                if (RaceBox.SelectedIndex != -1)
                {
                    switch (RaceBox.SelectedItem.ToString())
                    {
                        case "Dieu élémentaire":
                            HeightMin.Minimum = World.GodMinHeight;
                            HeightMax.Minimum = World.GodMinHeight;
                            HeightBox.Minimum = World.GodMinHeight;
                            HeightMin.Maximum = World.GodMaxHeight;
                            HeightMax.Maximum = World.GodMaxHeight;
                            HeightBox.Maximum = World.GodMaxHeight;
                            break;
                        default:
                            HeightMin.Minimum = World.PeopleMinHeight;
                            HeightMax.Minimum = World.PeopleMinHeight;
                            HeightBox.Minimum = World.PeopleMinHeight;
                            HeightMin.Maximum = World.PeopleMaxHeight;
                            HeightMax.Maximum = World.PeopleMaxHeight;
                            HeightBox.Maximum = World.PeopleMaxHeight;
                            break;
                    }
                }
                LW.Debug("Height Limits : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh Hair Color
        /// </summary>
        private void RefreshHairColor()
        {
            try
            {
                LW.Debug("Refreshing Hair Colors.");
                HairColorBox.Items.Clear();
                foreach (Hair val in HairList)
                {
                    HairColorBox.Items.Add(val.Color);
                }
                LW.Debug("Hair Colors : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh Hair Length
        /// </summary>
        private void RefreshHairLength()
        {
            try
            {
                LW.Debug("Refreshing Hair Lengths.");
                HairLengthBox.Items.Clear();
                foreach (Hair val in HairList)
                {
                    HairLengthBox.Items.Add(val.Length);
                }
                LW.Debug("Hair Length : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh Eyes Color
        /// </summary>
        private void RefreshEyesColor()
        {
            try
            {
                LW.Debug("Refreshing Eye Colors.");
                EyeColorBox.Items.Clear();
                foreach (string val in EC)
                {
                    EyeColorBox.Items.Add(val);
                }
                LW.Debug("Eye Colors : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh likes
        /// </summary>
        private void RefreshLikes()
        {
            try
            {
                LW.Debug("Refreshing Likes.");
                RefreshLike1();
                RefreshLike2();
                RefreshLike3();
                RefreshLike4();
                RefreshLike5();
                LW.Debug("Likes : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox1
        /// </summary>
        private void RefreshLike1()
        {
            try
            {
                LW.Debug("Refreshing Likes 1.");
                LikeBox1.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox5.SelectedIndex != -1) if (UnlikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        LikeBox1.Items.Add(value.Name);
                    }
                }
                LW.Debug("Likes 1 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox2
        /// </summary>
        private void RefreshLike2()
        {
            try
            {
                LW.Debug("Refreshing Likes 2.");
                LikeBox2.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox5.SelectedIndex != -1) if (UnlikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        LikeBox2.Items.Add(value.Name);
                    }
                }
                LW.Debug("Likes 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox3
        /// </summary>
        private void RefreshLike3()
        {
            try
            {
                LW.Debug("Refreshing Likes 3.");
                LikeBox3.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox5.SelectedIndex != -1) if (UnlikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        LikeBox3.Items.Add(value.Name);
                    }
                }
                LW.Debug("Likes 3 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox4
        /// </summary>
        private void RefreshLike4()
        {
            try
            {
                LW.Debug("Refreshing Likes 4.");
                LikeBox4.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox5.SelectedIndex != -1) if (UnlikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        LikeBox4.Items.Add(value.Name);
                    }
                }
                LW.Debug("Likes 4 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox5
        /// </summary>
        private void RefreshLike5()
        {
            try
            {
                LW.Debug("Refreshing Likes 5.");
                LikeBox5.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox5.SelectedIndex != -1) if (UnlikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        LikeBox5.Items.Add(value.Name);
                    }
                }
                LW.Debug("Likes 5 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh unlikes
        /// </summary>
        private void RefreshUnlikes()
        {
            try
            {
                LW.Debug("Refreshing Unlikes.");
                RefreshUnlike1();
                RefreshUnlike2();
                RefreshUnlike3();
                RefreshUnlike4();
                RefreshUnlike5();
                LW.Debug("Unlikes : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh UnlikeBox1
        /// </summary>
        private void RefreshUnlike1()
        {
            try
            {
                LW.Debug("Refreshing Unlikes 1.");
                UnlikeBox1.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox5.SelectedIndex != -1) if (LikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        UnlikeBox1.Items.Add(value.Name);
                    }
                }
                LW.Debug("Unlikes 1 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox2
        /// </summary>
        private void RefreshUnlike2()
        {
            try
            {
                LW.Debug("Refreshing Unlikes 2.");
                UnlikeBox2.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox5.SelectedIndex != -1) if (LikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        UnlikeBox2.Items.Add(value.Name);
                    }
                }
                LW.Debug("Unlikes 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox3
        /// </summary>
        private void RefreshUnlike3()
        {
            try
            {
                LW.Debug("Refreshing Unlikes 3.");
                UnlikeBox3.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox5.SelectedIndex != -1) if (LikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        UnlikeBox3.Items.Add(value.Name);
                    }
                }
                LW.Debug("Unlikes 3 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox4
        /// </summary>
        private void RefreshUnlike4()
        {
            try
            {
                LW.Debug("Refreshing Unlikes 4.");
                UnlikeBox4.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox5.SelectedIndex != -1) if (LikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        UnlikeBox4.Items.Add(value.Name);
                    }
                }
                LW.Debug("Unlikes 4 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh LikeBox5
        /// </summary>
        private void RefreshUnlike5()
        {
            try
            {
                LW.Debug("Refreshing Unlikes 5.");
                UnlikeBox5.Items.Clear();
                bool add;
                foreach (Thing value in Things)
                {
                    add = true;
                    if (UnlikeBox1.SelectedIndex != -1) if (UnlikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox2.SelectedIndex != -1) if (UnlikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox3.SelectedIndex != -1) if (UnlikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (UnlikeBox4.SelectedIndex != -1) if (UnlikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox1.SelectedIndex != -1) if (LikeBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox2.SelectedIndex != -1) if (LikeBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox3.SelectedIndex != -1) if (LikeBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox4.SelectedIndex != -1) if (LikeBox4.SelectedItem.ToString() == value.Name) add = false;
                    if (LikeBox5.SelectedIndex != -1) if (LikeBox5.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        UnlikeBox5.Items.Add(value.Name);
                    }
                }
                LW.Debug("Unlikes 5 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh activities
        /// </summary>
        private void RefreshActivities()
        {
            try
            {
                LW.Debug("Refreshing Activities.");
                RefreshActivity1();
                RefreshActivity2();
                RefreshActivity3();
                RefreshActivity4();
                LW.Debug("Activities : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ActivityBox1
        /// </summary>
        private void RefreshActivity1()
        {
            try
            {
                LW.Debug("Refreshing Activity 1.");
                ActBox1.Items.Clear();
                bool add;
                foreach (Activity value in Acts)
                {
                    add = true;
                    if (TimelineBox.SelectedIndex != -1)
                    {
                        if (value.Timeline.Name == TimelineBox.SelectedItem.ToString())
                        {
                            foreach (Character val in CharaList)
                            {
                                if (val.Activities.Contains(value))
                                {
                                    add = false;
                                }
                            }
                        }
                        else
                        {
                            add = false;
                        }
                    }
                    if (add)
                    {
                        ActBox1.Items.Add(value.Title);
                    }
                }
                LW.Debug("Activity 1 : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ActivityBox2
        /// </summary>
        private void RefreshActivity2()
        {
            try
            {
                LW.Debug("Refreshing Activity 2.");
                ActBox2.Items.Clear();
                bool add;
                foreach (Activity value in Acts)
                {
                    add = true;
                    if (TimelineBox.SelectedIndex != -1)
                    {
                        if (value.Timeline.Name == TimelineBox.SelectedItem.ToString())
                        {
                            foreach (Character val in CharaList)
                            {
                                if (val.Activities.Contains(value))
                                {
                                    add = false;
                                }
                            }
                        }
                        else
                        {
                            add = false;
                        }
                    }
                    if (ActBox1.SelectedIndex != -1) if (ActBox1.SelectedItem.ToString() == value.Title) add = false;
                    if (add)
                    {
                        ActBox2.Items.Add(value.Title);
                    }
                }
                LW.Debug("Activity 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ActivityBox3
        /// </summary>
        private void RefreshActivity3()
        {
            try
            {
                LW.Debug("Refreshing Activity 3.");
                ActBox3.Items.Clear();
                bool add;
                foreach (Activity value in Acts)
                {
                    add = true;
                    if (TimelineBox.SelectedIndex != -1)
                    {
                        if (value.Timeline.Name == TimelineBox.SelectedItem.ToString())
                        {
                            foreach (Character val in CharaList)
                            {
                                if (val.Activities.Contains(value))
                                {
                                    add = false;
                                }
                            }
                        }
                        else
                        {
                            add = false;
                        }
                    }
                    if (ActBox1.SelectedIndex != -1) if (ActBox1.SelectedItem.ToString() == value.Title) add = false;
                    if (ActBox2.SelectedIndex != -1) if (ActBox2.SelectedItem.ToString() == value.Title) add = false;
                    if (add)
                    {
                        ActBox3.Items.Add(value.Title);
                    }
                }
                LW.Debug("Activity 3 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh ActivityBox4
        /// </summary>
        private void RefreshActivity4()
        {
            try
            {
                LW.Debug("Refreshing Activity 4.");
                ActBox4.Items.Clear();
                bool add;
                foreach (Activity value in Acts)
                {
                    add = true;
                    if (TimelineBox.SelectedIndex != -1)
                    {
                        if (value.Timeline.Name == TimelineBox.SelectedItem.ToString())
                        {
                            foreach (Character val in CharaList)
                            {
                                if (val.Activities.Contains(value))
                                {
                                    add = false;
                                }
                            }
                        }
                        else
                        {
                            add = false;
                        }
                    }
                    if (ActBox1.SelectedIndex != -1) if (ActBox1.SelectedItem.ToString() == value.Title) add = false;
                    if (ActBox2.SelectedIndex != -1) if (ActBox2.SelectedItem.ToString() == value.Title) add = false;
                    if (ActBox3.SelectedIndex != -1) if (ActBox3.SelectedItem.ToString() == value.Title) add = false;
                    if (add)
                    {
                        ActBox4.Items.Add(value.Title);
                    }
                }
                LW.Debug("Activity 4 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh weapons
        /// </summary>
        private void RefreshWeapons()
        {
            try
            {
                LW.Debug("Refreshing Weapons.");
                RefreshWeapon1();
                RefreshWeapon2();
                RefreshWeapon3();
                RefreshWeapon4();
                LW.Debug("Weapons : OK.");
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh WeaponBox1
        /// </summary>
        private void RefreshWeapon1()
        {
            try
            {
                LW.Debug("Refreshing Weapon 1.");
                WeaponBox1.Items.Clear();
                bool add;
                foreach (Weapon value in Weapons)
                {
                    add = true;
                    if (value.Special)
                    {
                        foreach (Character val in CharaList)
                        {
                            if (val.Weapons.Contains(value))
                            {
                                add = false;
                            }
                        }
                        if (value.Element != null)
                        {
                            if (ElementBox.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox.SelectedItem.ToString())
                                {
                                    if (ElementBox2.SelectedIndex != -1)
                                    {
                                        if (value.Element != ElementBox2.SelectedItem.ToString()) add = false;
                                    }
                                    else
                                    {
                                        add = false;
                                    }
                                }
                            }
                            else
                            {
                                add = false;
                            }
                        }
                    }
                    if (add)
                    {
                        WeaponBox1.Items.Add(value.Name);
                    }
                }
                LW.Debug("Weapon 1 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh WeaponBox2
        /// </summary>
        private void RefreshWeapon2()
        {
            try
            {
                LW.Debug("Refreshing Weapon 2.");
                WeaponBox2.Items.Clear();
                bool add;
                foreach (Weapon value in Weapons)
                {
                    add = true;
                    if (value.Special)
                    {
                        foreach (Character val in CharaList)
                        {
                            if (val.Weapons.Contains(value))
                            {
                                add = false;
                            }
                        }
                        if (value.Element != null)
                        {
                            if (ElementBox.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox.SelectedItem.ToString()) add = false;
                            }
                            if (ElementBox2.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox2.SelectedItem.ToString()) add = false;
                            }
                        }
                    }
                    if (WeaponBox1.SelectedIndex != -1) if (WeaponBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        WeaponBox2.Items.Add(value.Name);
                    }
                }
                LW.Debug("Weapon 2 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh WeaponBox3
        /// </summary>
        private void RefreshWeapon3()
        {
            try
            {
                LW.Debug("Refreshing Weapon 3.");
                WeaponBox3.Items.Clear();
                bool add;
                foreach (Weapon value in Weapons)
                {
                    add = true;
                    if (value.Special)
                    {
                        foreach (Character val in CharaList)
                        {
                            if (val.Weapons.Contains(value))
                            {
                                add = false;
                            }
                        }
                        if (value.Element != null)
                        {
                            if (ElementBox.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox.SelectedItem.ToString()) add = false;
                            }
                            if (ElementBox2.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox2.SelectedItem.ToString()) add = false;
                            }
                        }
                    }
                    if (WeaponBox1.SelectedIndex != -1) if (WeaponBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (WeaponBox2.SelectedIndex != -1) if (WeaponBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        WeaponBox3.Items.Add(value.Name);
                    }
                }
                LW.Debug("Weapon 3 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Refresh WeaponBox4
        /// </summary>
        private void RefreshWeapon4()
        {
            try
            {
                LW.Debug("Refreshing Weapon 4.");
                WeaponBox4.Items.Clear();
                bool add;
                foreach (Weapon value in Weapons)
                {
                    add = true;
                    if (value.Special)
                    {
                        foreach (Character val in CharaList)
                        {
                            if (val.Weapons.Contains(value))
                            {
                                add = false;
                            }
                        }
                        if (value.Element != null)
                        {
                            if (ElementBox.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox.SelectedItem.ToString()) add = false;
                            }
                            if (ElementBox2.SelectedIndex != -1)
                            {
                                if (value.Element != ElementBox2.SelectedItem.ToString()) add = false;
                            }
                        }
                    }
                    if (WeaponBox1.SelectedIndex != -1) if (WeaponBox1.SelectedItem.ToString() == value.Name) add = false;
                    if (WeaponBox2.SelectedIndex != -1) if (WeaponBox2.SelectedItem.ToString() == value.Name) add = false;
                    if (WeaponBox3.SelectedIndex != -1) if (WeaponBox3.SelectedItem.ToString() == value.Name) add = false;
                    if (add)
                    {
                        WeaponBox4.Items.Add(value.Name);
                    }
                }
                LW.Debug("Weapon 4 : OK.");
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }
        #endregion Refresh functions

        #region Refresh App Changes
        /// <summary>
        /// Timeline changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TimelineBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Timeline changed.");
            RefreshActivities();
        }

        /// <summary>
        /// Race changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RaceBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Race changed.");
            RefreshLNames();
            RefreshFNames();
            RefreshHeightLimit();
        }

        /// <summary>
        /// Element changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ElementBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Element 1 changed.");
            RefreshElements2();
            RefreshWeapons();
        }

        /// <summary>
        /// Element 2 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ElementBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Element 2 changed.");
            RefreshWeapons();
        }

        /// <summary>
        /// Power changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void PowerBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Power 1 changed.");
            RefreshPowers2();
        }

        /// <summary>
        /// Like 1 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LikeBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Like 1 changed.");
            RefreshLike2();
            RefreshLike3();
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike1();
            RefreshUnlike2();
            RefreshUnlike3();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Like 2 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LikeBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Like 2 changed.");
            RefreshLike3();
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike2();
            RefreshUnlike3();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Like 3 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LikeBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Like 3 changed.");
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike3();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Like 4 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LikeBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Like 4 changed.");
            RefreshLike5();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Like 5 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LikeBox5_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Like 5 changed.");
            RefreshUnlike5();
        }

        /// <summary>
        /// Unlike 1 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UnlikeBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Unlike 1 changed.");
            RefreshLike2();
            RefreshLike3();
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike2();
            RefreshUnlike3();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Unlike 2 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UnlikeBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Unlike 2 changed.");
            RefreshLike3();
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike3();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Unlike 3 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UnlikeBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Unlike 3 changed.");
            RefreshLike4();
            RefreshLike5();
            RefreshUnlike4();
            RefreshUnlike5();
        }

        /// <summary>
        /// Unlike 4 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void UnlikeBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Unlike 4 changed.");
            RefreshLike5();
            RefreshUnlike5();
        }

        /// <summary>
        /// Activity 1 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ActBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Activity 1 changed.");
            RefreshActivity2();
            RefreshActivity3();
            RefreshActivity4();
        }

        /// <summary>
        /// Activity 2 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ActBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Activity 2 changed.");
            RefreshActivity3();
            RefreshActivity4();
        }

        /// <summary>
        /// Activity 3 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ActBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Activity 3 changed.");
            RefreshActivity4();
        }

        /// <summary>
        /// BirthMonth changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void BirthMonth_ValueChanged(object sender, EventArgs e)
        {
            LW.Debug("Birth month changed.");
            RefreshDatesLimit();
        }

        /// <summary>
        /// Weapon 1 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void WeaponBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Weapon 1 changed.");
            RefreshWeapon2();
            RefreshWeapon3();
            RefreshWeapon4();
        }

        /// <summary>
        /// Weapon 2 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void WeaponBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Weapon 2 changed.");
            RefreshWeapon3();
            RefreshWeapon4();
        }

        /// <summary>
        /// Weapon 3 changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void WeaponBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            LW.Debug("Weapon 3 changed.");
            RefreshWeapon4();
        }
        #endregion Refresh App Changes

        /// <summary>
        /// Random generating
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cmdRandom_Click(object sender, EventArgs e)
        {
            try
            {
                LW.Debug("Randomizing...");
                if (TimelineBox.SelectedIndex == -1) TimelineBox.SelectedIndex = Rnd.Next(0, TimelineBox.Items.Count - 2);//*Originelle is not a good Timeline.
                if (RaceBox.SelectedIndex == -1) RaceBox.SelectedIndex = Rnd.Next(2, RaceBox.Items.Count - 1);
                if (ElementBox.SelectedIndex == -1) ElementBox.SelectedIndex = Rnd.Next(0, ElementBox.Items.Count - 1);
                if (ElementBox2.SelectedIndex == -1)
                {
                    if (Rnd.Next(0, 500) == 1) ElementBox2.SelectedIndex = Rnd.Next(0, ElementBox2.Items.Count - 1);
                }
                if (PowerBox.SelectedIndex == -1) PowerBox.SelectedIndex = Rnd.Next(0, PowerBox.Items.Count - 1);
                if (PowerBox2.SelectedIndex == -1)
                {
                    if (Rnd.Next(0, 1000) == 1) PowerBox2.SelectedIndex = Rnd.Next(0, PowerBox2.Items.Count - 1);
                }
                #region Dates
                if (BirthDay.Value == 1 && BirthMonth.Value == 1 && BirthYear.Value == 0)
                {
                    BirthDay.Value = Rnd.Next((int)BirthDay.Minimum, (int)BirthDay.Maximum);
                    BirthMonth.Value = Rnd.Next((int)BirthMonth.Minimum, (int)BirthMonth.Maximum);
                    try
                    {
                        BirthYear.Value = Rnd.Next((int)BirthYearMin.Value, (int)BirthYearMax.Value);
                    }
                    catch(Exception ex)
                    {
                        LW.Error(ex);
                        BirthYear.Value = 0;
                        MessageBox.Show("Invalid Min and Max Years.", ">:(");
                    }
                }
                else if(BirthDay.Value == 1 && BirthMonth.Value == 1)
                {
                    BirthDay.Value = Rnd.Next((int)BirthDay.Minimum, (int)BirthDay.Maximum);
                    BirthMonth.Value = Rnd.Next((int)BirthMonth.Minimum, (int)BirthMonth.Maximum);
                }
                else if(BirthYear.Value == 0)
                {
                    try
                    {
                        BirthYear.Value = Rnd.Next((int)BirthYearMin.Value, (int)BirthYearMax.Value);
                    }
                    catch (Exception ex)
                    {
                        LW.Error(ex);
                        BirthYear.Value = 0;
                        MessageBox.Show("Invalid Min and Max Years.", ">:(");
                    }
                }
                #endregion Dates
                #region Height
                if (RaceBox.SelectedItem.ToString() == "Dieu élémentaire")
                {
                    try
                    {
                        if (HeightBox.Value == World.GodMinHeight) HeightBox.Value = Rnd.Next((int)HeightMin.Value, (int)HeightMax.Value);
                    }
                    catch (Exception ex)
                    {
                        LW.Error(ex);
                        BirthYear.Value = 0;
                        MessageBox.Show("Invalid Min and Max Height.", ">:(");
                    }
                }
                else
                {
                    try
                    {
                        if (HeightBox.Value == World.PeopleMinHeight || HeightBox.Value == World.PeopleMaxHeight) HeightBox.Value = Rnd.Next((int)HeightMin.Value, (int)HeightMax.Value);
                    }
                    catch (Exception ex)
                    {
                        LW.Error(ex);
                        BirthYear.Value = 0;
                        MessageBox.Show("Invalid Min and Max Height.", ">:(");
                    }
                }
                #endregion Height
                if (HairColorBox.SelectedIndex == -1)
                {
                    if ((string)HairColorBox.Text == "") HairColorBox.SelectedIndex = Rnd.Next(0, HairColorBox.Items.Count - 1);
                }
                if (HairLengthBox.SelectedIndex == -1)
                {
                    if ((string)HairLengthBox.Text == "") HairLengthBox.SelectedIndex = Rnd.Next(0, HairLengthBox.Items.Count - 1);
                }
                if (EyeColorBox.SelectedIndex == -1)
                {
                    if ((string)EyeColorBox.Text == "") EyeColorBox.SelectedIndex = Rnd.Next(0, EyeColorBox.Items.Count - 1);
                }
                if (LikeBox1.SelectedIndex == -1) LikeBox1.SelectedIndex = Rnd.Next(0, LikeBox1.Items.Count - 1);
                if (UnlikeBox1.SelectedIndex == -1) UnlikeBox1.SelectedIndex = Rnd.Next(0, UnlikeBox1.Items.Count - 1);
                if (LikeBox2.SelectedIndex == -1) LikeBox2.SelectedIndex = Rnd.Next(0, LikeBox2.Items.Count - 1);
                if (UnlikeBox2.SelectedIndex == -1) UnlikeBox2.SelectedIndex = Rnd.Next(0, UnlikeBox2.Items.Count - 1);
                if (WeaponBox1.SelectedIndex == -1)
                {
                    if (Rnd.Next(0, 30) != 0)
                    {
                        Redo:
                        WeaponBox1.SelectedIndex = Rnd.Next(0, WeaponBox1.Items.Count - 1);
                        foreach (Weapon value in Weapons)
                        {
                            if (value.Name == WeaponBox1.SelectedIndex.ToString())
                            {
                                if (value.Special)
                                {
                                    goto Redo;
                                }
                            }
                        }
                        if (Rnd.Next(0, 2) == 0)
                        {
                            Redo2:
                            WeaponBox2.SelectedIndex = Rnd.Next(0, WeaponBox1.Items.Count - 1);
                            foreach (Weapon value in Weapons)
                            {
                                if (value.Name == WeaponBox2.SelectedIndex.ToString())
                                {
                                    if (value.Special)
                                    {
                                        goto Redo2;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Validation of Character
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cmdValidate_Click(object sender, EventArgs e)
        {
            try
            {
                LW.Debug("Validating...");
                int t = -1, r = -1, e1 = -1, e2 = -1, p1 = -1, p2 = -1, l1 = -1, l2 = -1, l3 = -1, l4 = -1, l5 = -1,
                    u1 = -1, u2 = -1, u3 = -1, u4 = -1, u5 = -1, a1 = -1, a2 = -1, a3 = -1, a4 = -1,
                    w1 = -1, w2 = -1, w3 = -1, w4 = -1, i;
                //Alternative character
                if (AltCheckBox.Checked)
                {
                    MessageBox.Show("Alternative character unavailable.");
                }
                else
                {
                    //Timeline
                    if (TimelineBox.SelectedIndex == -1)
                    {
                        MessageBox.Show("Enter a Timeline.");
                        throw new Exception();
                    }
                    else
                    {
                        i = 0;
                        foreach(Timeline value in TLs)
                        {
                            if (value.Name == TimelineBox.SelectedItem.ToString()) t = i;
                            i++;
                        }
                    }
                    //Race
                    if (RaceBox.SelectedIndex == -1)
                    {
                        MessageBox.Show("Enter a Race.");
                        throw new Exception();
                    }
                    else
                    {
                        i = 0;
                        foreach (Race value in Races)
                        {
                            if (value.Name == RaceBox.SelectedItem.ToString()) r = i;
                            i++;
                        }
                    }
                    //Ndf + Fn
                    if (Races[r].Name == "Dragon")
                    {
                        if (FNameBox.SelectedIndex == -1)
                        {
                            MessageBox.Show("Select a First Name.");
                            throw new Exception();
                        }
                    }
                    else
                    {
                        if (LNameBox.Text == "" || FNameBox.Text == "")
                        {
                            MessageBox.Show("Enter a Last and First Names.");
                            throw new Exception();
                        }
                    }
                    //Elements
                    if (ElementBox.SelectedIndex == -1)
                    {
                        MessageBox.Show("Select at least 1 element.");
                        throw new Exception();
                    }
                    else
                    {
                        i = 0;
                        foreach (string value in W.Elements)
                        {
                            if (value == ElementBox.SelectedItem.ToString()) e1 = i;
                            if (ElementBox2.SelectedIndex != -1) if (value == ElementBox2.SelectedItem.ToString()) e2 = i;
                            i++;
                        }
                    }
                    //Powers
                    if (PowerBox.SelectedIndex == -1)
                    {
                        MessageBox.Show("Select at least 1 power.");
                        throw new Exception();
                    }
                    else
                    {
                        i = 0;
                        foreach (Power value in Powers)
                        {
                            if (value.Name == PowerBox.SelectedItem.ToString()) p1 = i;
                            if (PowerBox2.SelectedIndex != -1) if (value.Name == PowerBox2.SelectedItem.ToString()) p2 = i;
                            i++;
                        }
                    }
                    //Hair and Eyes
                    if (HairColorBox.Text == "" || HairLengthBox.Text == "" || EyeColorBox.Text == "")
                    {
                        MessageBox.Show("Enter Hair and eyes.");
                        throw new Exception();
                    }
                    //Likes and Unlikes
                    if (LikeBox1.SelectedIndex == -1 || UnlikeBox1.SelectedIndex == -1)
                    {
                        MessageBox.Show("Select at least 1 like and unlike.");
                        throw new Exception();
                    }
                    else
                    {
                        i = 0;
                        foreach(Thing value in Things)
                        {
                            if (value.Name == LikeBox1.SelectedItem.ToString()) l1 = i;
                            if (value.Name == UnlikeBox1.SelectedItem.ToString()) u1 = i;
                            if (LikeBox2.SelectedIndex != -1) if (value.Name == LikeBox2.SelectedItem.ToString()) l2 = i;
                            if (UnlikeBox2.SelectedIndex != -1) if (value.Name == UnlikeBox2.SelectedItem.ToString()) u2 = i;
                            if (LikeBox3.SelectedIndex != -1) if (value.Name == LikeBox3.SelectedItem.ToString()) l3 = i;
                            if (UnlikeBox3.SelectedIndex != -1) if (value.Name == UnlikeBox3.SelectedItem.ToString()) u3 = i;
                            if (LikeBox4.SelectedIndex != -1) if (value.Name == LikeBox4.SelectedItem.ToString()) l4 = i;
                            if (UnlikeBox4.SelectedIndex != -1) if (value.Name == UnlikeBox4.SelectedItem.ToString()) u4 = i;
                            if (LikeBox5.SelectedIndex != -1) if (value.Name == LikeBox5.SelectedItem.ToString()) l5 = i;
                            if (UnlikeBox5.SelectedIndex != -1) if (value.Name == UnlikeBox5.SelectedItem.ToString()) u5 = i;
                            i++;
                        }
                    }
                    //Activity
                    i = 0;
                    foreach (Activity value in Acts)
                    {
                        if (ActBox1.SelectedIndex != -1) if (value.Title == ActBox1.SelectedItem.ToString()) a1 = i;
                        if (ActBox2.SelectedIndex != -1) if (value.Title == ActBox2.SelectedItem.ToString()) a2 = i;
                        if (ActBox3.SelectedIndex != -1) if (value.Title == ActBox3.SelectedItem.ToString()) a3 = i;
                        if (ActBox4.SelectedIndex != -1) if (value.Title == ActBox4.SelectedItem.ToString()) a4 = i;
                        i++;
                    }
                    //Backstory
                    if (BackstoryBox.Text == "")
                    {
                        MessageBox.Show("Enter a backstory.");
                        throw new Exception();
                    }
                    //Weapon
                    i = 0;
                    foreach (Weapon value in Weapons)
                    {
                        if (WeaponBox1.SelectedIndex != -1) if (value.Name == WeaponBox1.SelectedItem.ToString()) w1 = i;
                        if (WeaponBox2.SelectedIndex != -1) if (value.Name == WeaponBox2.SelectedItem.ToString()) w2 = i;
                        if (WeaponBox3.SelectedIndex != -1) if (value.Name == WeaponBox3.SelectedItem.ToString()) w3 = i;
                        if (WeaponBox4.SelectedIndex != -1) if (value.Name == WeaponBox4.SelectedItem.ToString()) w4 = i;
                        i++;
                    }
                    //Creation of character
                    Character c;
                    if (Races[r].Name == "Dragon")
                    {
                        c = new Character(new LastName("Dragon", Races[r]), (string)FNameBox.Text, new Hair((string)HairColorBox.Text, (string)HairLengthBox.Text),
                            (string)EyeColorBox.Text, Races[r], (int)HeightBox.Value, new TimeDate((int)BirthYear.Value, (int)BirthMonth.Value, (int)BirthDay.Value), TLs[t]);
                    }
                    else
                    {
                        c = new Character(new LastName((string)LNameBox.Text, Races[r]), (string)FNameBox.Text, new Hair((string)HairColorBox.Text, (string)HairLengthBox.Text),
                            (string)EyeColorBox.Text, Races[r], (int)HeightBox.Value, new TimeDate((int)BirthYear.Value, (int)BirthMonth.Value, (int)BirthDay.Value), TLs[t]);
                    }
                    if (e1 != -1) c.Elements.Add(W.Elements[e1]);
                    if (e2 != -1) c.Elements.Add(W.Elements[e2]);
                    if (p1 != -1) c.Powers.Add(Powers[p1]);
                    if (p2 != -1) c.Powers.Add(Powers[p2]);
                    if (l1 != -1) c.Likes.Add(Things[l1]);
                    if (l2 != -1) c.Likes.Add(Things[l2]);
                    if (l3 != -1) c.Likes.Add(Things[l3]);
                    if (l4 != -1) c.Likes.Add(Things[l4]);
                    if (l5 != -1) c.Likes.Add(Things[l5]);
                    if (u1 != -1) c.Unlikes.Add(Things[u1]);
                    if (u2 != -1) c.Unlikes.Add(Things[u2]);
                    if (u3 != -1) c.Unlikes.Add(Things[u3]);
                    if (u4 != -1) c.Unlikes.Add(Things[u4]);
                    if (u5 != -1) c.Unlikes.Add(Things[u5]);
                    if (a1 != -1) c.Activities.Add(Acts[a1]);
                    if (a2 != -1) c.Activities.Add(Acts[a2]);
                    if (a3 != -1) c.Activities.Add(Acts[a3]);
                    if (a4 != -1) c.Activities.Add(Acts[a4]);
                    if (w1 != -1) c.Weapons.Add(Weapons[w1]);
                    if (w2 != -1) c.Weapons.Add(Weapons[w2]);
                    if (w3 != -1) c.Weapons.Add(Weapons[w3]);
                    if (w4 != -1) c.Weapons.Add(Weapons[w4]);
                    c.Backstory.Add(new BackStory("Unamed", BackstoryBox.Text, TLs[t]));
                    CharaList.Add(c);
                    //Reset
                    Reset();
                }
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        private void cmdCharaList_Click(object sender, EventArgs e)
        {
            try
            {
                LW.Debug("Showing Characters List...");
                ListForm LF = new ListForm(CharaList, LW);
                LF.Show();
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Saving Characters
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cmdSave_Click(object sender, EventArgs e)
        {
            try
            {
                LW.Debug("Saving...");
                SaveFileDialog SFD = new SaveFileDialog();
                SFD.InitialDirectory = System.IO.Directory.GetCurrentDirectory();
                SFD.RestoreDirectory = true;
                SFD.Title = "Save CharaList as...";
                SFD.DefaultExt = "bin";
                SFD.Filter = "bin files (*.bin)|*.bin";
                SFD.FilterIndex = 0;
                if (SFD.ShowDialog() == DialogResult.OK)
                {
                    SB.exportObject(CharaList, SFD.FileName);
                    Reset();
                }
            }
            catch(Exception ex)
            {
                LW.Error(ex);
            }
        }

        /// <summary>
        /// Loading Characters
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cmdLoad_Click(object sender, EventArgs e)
        {
            try
            {
                LW.Debug("Loading...");
                OpenFileDialog OFD = new OpenFileDialog();
                OFD.InitialDirectory = System.IO.Directory.GetCurrentDirectory();
                OFD.RestoreDirectory = true;
                OFD.Title = "Open CharaList";
                OFD.DefaultExt = "bin";
                OFD.Filter = "bin files (*.bin)|*.bin";
                OFD.FilterIndex = 0;
                if (OFD.ShowDialog() == DialogResult.OK)
                {
                    CharaList = (List<Character>)SB.importObject(OFD.FileName);
                    Reset();
                }
            }
            catch (Exception ex)
            {
                LW.Error(ex);
            }
        }
    }
}
