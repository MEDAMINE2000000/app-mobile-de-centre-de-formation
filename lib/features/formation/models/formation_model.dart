import 'package:flutter/material.dart';

class FormationCategory {
  final String id;
  final String name;
  final int count;
  final IconData icon;

  const FormationCategory({
    required this.id,
    required this.name,
    required this.count,
    required this.icon,
  });
}

class Formation {
  final String
  id; // ← لازم يكون موجود، حتى تقدر تربط الـ inscription بالـ formation
  final String title;
  final String description;
  final String imageUrl;
  final IconData badgeIcon;
  final String categoryName;
  final String categoryId;
  final String duration;
  final String level;
  // ...

  const Formation({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.duration,
    required this.level,
    required this.description,
    required this.imageUrl,
    required this.badgeIcon,
  });
}

class FormationMockData {
  static const List<FormationCategory> categories = [
    FormationCategory(
      id: 'toutes',
      name: 'Toutes',
      count: 15,
      icon: Icons.grid_view_rounded,
    ),
    FormationCategory(
      id: 'marketing',
      name: 'Marketing',
      count: 1,
      icon: Icons.campaign_rounded,
    ),
    FormationCategory(
      id: 'data',
      name: 'Data',
      count: 1,
      icon: Icons.pie_chart_rounded,
    ),
    FormationCategory(
      id: 'design',
      name: 'Design',
      count: 1,
      icon: Icons.draw_rounded,
    ),
    FormationCategory(
      id: 'informatique',
      name: 'Informatique',
      count: 2,
      icon: Icons.laptop_chromebook_rounded,
    ),
    FormationCategory(
      id: 'media',
      name: 'Media',
      count: 6,
      icon: Icons.headset_mic_rounded,
    ),
    FormationCategory(
      id: 'development',
      name: 'Development',
      count: 2,
      icon: Icons.code_rounded,
    ),
    FormationCategory(
      id: '3d',
      name: '3D',
      count: 1,
      icon: Icons.view_in_ar_rounded,
    ),
    FormationCategory(
      id: 'ai',
      name: 'AI',
      count: 1,
      icon: Icons.psychology_rounded,
    ),
  ];

  static const List<Formation> formations = [
    Formation(
      id: '1',
      title: 'Formation Marketing Digital International',
      categoryId: 'marketing',
      categoryName: 'Marketing',
      duration: '40H',
      level: 'Tous niveaux',
      description:
          'Le marketing digital traditionnel est lent et coûteux. Ce programme pose les bases de la révolution générative et vous montre comment l\'IA transforme radicalement le ROI de vos campagnes modernes.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/marketing_1787240692846.jpg',
=======
      imageUrl: 'assets/welcome/women_marketing.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.campaign_rounded,
    ),
    Formation(
      id: '2',
      title: 'Formation Power BI',
      categoryId: 'data',
      categoryName: 'Data',
      duration: '35H',
      level: 'Intermédiaire',
      description:
          'Apprenez à maîtriser Power BI pour une analyse de données avancée et efficace !',
<<<<<<< HEAD
      imageUrl: 'assets/formations/powerbi_1787240703485.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails2.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.pie_chart_rounded,
    ),
    Formation(
      id: '3',
      title: 'Formation Design Graphique & IA',
      categoryId: 'design',
      categoryName: 'Design',
      duration: '40H',
      level: 'Tous niveaux',
      description:
          'Savoir seulement cliquer dans Photoshop ne suffit plus. Cette formation intensive de 40 heures est le seul programme qui t\'apprend le vrai workflow des agences modernes : générer avec l\'IA.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/design_ia_1787240714521.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails1.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.palette_rounded,
    ),
    Formation(
      id: '4',
      title: 'Formation Bureautique Microsoft Office',
      categoryId: 'informatique',
      categoryName: 'Informatique',
      duration: '30H',
      level: 'Débutant',
      description:
          'Maîtrisez les outils Microsoft Office avec Three Alfa et optimisez votre productivité !',
<<<<<<< HEAD
      imageUrl: 'assets/formations/office_1787240724912.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails1.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.laptop_chromebook_rounded,
    ),
    Formation(
      id: '5',
      title: 'Formation Montage Vidéo',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '40H',
      level: 'Tous niveaux',
      description:
          'Apprenez les techniques de tournage et de montage vidéo pour créer des productions de qualité professionnelle !',
<<<<<<< HEAD
      imageUrl: 'assets/formations/video_editing_1787240736743.jpg',
=======
      imageUrl: 'assets/welcome/women_marketing.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.movie_creation_rounded,
    ),
    Formation(
      id: '6',
      title: 'Formation Photographie et Vidéographie',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '40H',
      level: 'Tous niveaux',
      description:
          'Apprenez les techniques professionnelles de photographie et vidéographie pour capturer des moments inoubliables !',
<<<<<<< HEAD
      imageUrl: 'assets/formations/photo_video_1787240746610.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails2.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.camera_alt_rounded,
    ),
    Formation(
      id: '7',
      title: 'Pack Media Digital',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '180H',
      level: 'Avancé',
      description:
          'Devenez un Expert Créatif et Digital grâce à des Techniques avancées de Marketing Digital, Design Graphique innovant et Photographie professionnelle.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/media_digital_1787240759196.jpg',
=======
      imageUrl: 'assets/welcome/women_marketing.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.headset_mic_rounded,
    ),
    Formation(
      id: '8',
      title: 'Bootcamp Développement Web Full Stack - MERN',
      categoryId: 'development',
      categoryName: 'Development',
      duration: '250H',
      level: 'Débutant à Avancé',
      description:
          'Apprenez à développer des applications web complètes avec la stack MERN, de l\'authentification sécurisée au déploiement !',
<<<<<<< HEAD
      imageUrl: 'assets/formations/web_dev_1787240770318.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails1.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.code_rounded,
    ),
    Formation(
      id: '9',
      title: 'Pack Junior + IA',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '35H',
      level: 'Junior',
      description:
          'Transformez leur temps d\'écran en compétences professionnelles. Ce bootcamp intensif plonge les jeunes créateurs dans les véritables conditions d\'une agence digitale.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/junior_ia_1787240924735.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails2.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.child_care_rounded,
    ),
    Formation(
      id: '10',
      title: 'Pack Créateur Pro',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '80H',
      level: 'Professionnel',
      description:
          'Maîtriser la photographie numérique, la vidéographie, ainsi que le montage professionnel sur Adobe Premiere Pro et After Effects.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/createur_pro_1787240938421.jpg',
=======
      imageUrl: 'assets/welcome/women_marketing.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.videocam_rounded,
    ),
    Formation(
      id: '11',
      title: 'Blender 3D',
      categoryId: '3d',
      categoryName: '3D',
      duration: '52H',
      level: 'Tous niveaux',
      description:
          'Créez des objets 3D et des animations réalistes pour le jeu vidéo et le cinéma avec Blender.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/blender_1787240949734.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails1.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.view_in_ar_rounded,
    ),
    Formation(
      id: '12',
      title: 'Bootcamp IA Générative',
      categoryId: 'ai',
      categoryName: 'AI',
      duration: '24H',
      level: 'Tous niveaux',
      description:
          'Une formation intensive pensée pour les créatifs, les responsables marketing et les entrepreneurs qui veulent maîtriser les standards de l\'industrie (ChatGPT, Claude, Midjourney, Perplexity, Runway).',
<<<<<<< HEAD
      imageUrl: 'assets/formations/ai_bootcamp_1787240961681.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails2.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.psychology_rounded,
    ),
    Formation(
      id: '13',
      title: 'Pack Junior 2.0',
      categoryId: 'media',
      categoryName: 'Media',
      duration: '70H',
      level: 'Junior',
      description:
          'Une immersion pratique de 2 semaines (10 jours) pour maîtriser la création visuelle de A à Z : du scénario et de la prise de vue au montage vidéo, design d\'affiche et miniatures IA.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/junior_2_1787240974254.jpg',
=======
      imageUrl: 'assets/welcome/women_marketing.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.auto_awesome_motion_rounded,
    ),
    Formation(
      id: '14',
      title: 'Excel Expert',
      categoryId: 'informatique',
      categoryName: 'Informatique',
      duration: '20H',
      level: 'Expert',
      description:
          'Excel est l\'outil indispensable du monde professionnel. Cette formation accélérée et 100% pratique de 20 heures est spécialement conçue pour vous faire passer d\'un niveau intermédiaire à un niveau Expert.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/office_1787240724912.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails1.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.table_chart_rounded,
    ),
    Formation(
      id: '15',
      title: 'Développement de Jeux Vidéo (Unity & C#)',
      categoryId: 'development',
      categoryName: 'Development',
      duration: '60H',
      level: 'Tous niveaux',
      description:
          'Immergez dans le pipeline complet de production d\'un jeu vidéo. De la logique de programmation en C# jusqu\'à l\'exportation et la publication sur les stores.',
<<<<<<< HEAD
      imageUrl: 'assets/formations/blender_1787240949734.jpg',
=======
      imageUrl: 'assets/welcome/thumbnails/thumbnails2.jpg',
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      badgeIcon: Icons.sports_esports_rounded,
    ),
  ];
}
