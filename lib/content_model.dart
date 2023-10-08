class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Purpose',
      image: 'assets/images/detail_head.png',
      discription: "Healing Bee is a pioneering platform focused on enhancing mental wellness "
          "Our core mission is to provide users with innovative tools to better understand and improve their mental health.  "
          "Whether you're looking to assess your mental health or receive personalized content tailored to your unique needs, Healing Bee is here to guide you on your journey to a healthier mind"
  ),
  UnbordingContent(
      title: 'Security',
      image: 'assets/images/detail_head.png',
      discription: "Security and privacy are paramount at Healing Bee. We've implemented stringent measures to safeguard user data. "
          "You can trust Healing Bee to maintain the highest standards of data security, allowing you to engage with our platform with confidence. "
  ),
  UnbordingContent(
      title: 'Mobile App',
      image: 'assets/images/detail_head.png',
      discription: "The Healing Bee mobile application is designed with user convenience in mind. "
          "It provides a seamless experience for users to take voice-based assessments, receive scores, and gain insights into their mental wellness. "
          " Healing Bee empowers individuals to prioritize and take control of their mental health with ease and confidence. "
  ),
];