class PetDescription {
  String? species;
  String? description;
  String? characterstics;
  String? heights;
  String? lifeSpan;
  String? colors;
  String? diet;
  String? homeCare;
  String? exercises;
  String? frequentConcern;
  String? warningSymptoms;
  String? image;

  PetDescription({this.species, this.description, this.characterstics, this.heights, this.lifeSpan, this.colors, this.diet, this.homeCare, this.exercises, this.frequentConcern, this.warningSymptoms,this.image});

  factory PetDescription.fromJson(Map<String, dynamic> json) {
    return PetDescription(
      species: json['Species'],
      description: json['Description'],
      characterstics: json['Characterstics'],
      heights: json['Heights'],
      lifeSpan: json['Life Span'],
      colors: json['Colors'],
      diet: json['Diet'],
      homeCare: json['Home Care'],
      exercises: json['Exercises'],
      frequentConcern: json['Frequent Concern'],
      warningSymptoms: json['Warning Symptoms'],
      image: json['image'],
    );
  }
  factory PetDescription.fromMap(Map<String, dynamic> map) {
    return PetDescription(
      species: map['Species'] ?? '',
      description: map['Description'] ?? '',
      characterstics: map['Characterstics'] ?? '',
      heights: map['Heights'] ?? '',
      lifeSpan: map['Life Span'] ?? '',
      colors: map['Colors'] ?? '',
      diet: map['Diet'] ?? '',
      homeCare: map['Home Care'] ?? '',
      exercises: map['Exercises'] ?? '',
      frequentConcern: map['Frequent Concern'] ?? '',
      warningSymptoms: map['Warning Symptoms'] ?? '',
      image: map['image'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Species': species,
      'Description': description,
      'Characterstics': characterstics,
      'Heights': heights,
      'Life Span': lifeSpan,
      'Colors': colors,
      'Diet': diet,
      'Home Care': homeCare,
      'Exercises': exercises,
      'Frequent Concern': frequentConcern,
      'Warning Symptoms': warningSymptoms,
      'image': image,
    };
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Species'] = species;
    data['Description'] = description;
    data['Characterstics'] = characterstics;
    data['Heights'] = heights;
    data['Life Span'] = lifeSpan;
    data['Colors'] = colors;
    data['Diet'] = diet;
    data['Home Care'] = homeCare;
    data['Exercises'] = exercises;
    data['Frequent Concern'] = frequentConcern;
    data['Warning Symptoms'] = warningSymptoms;
    data['image'] = image;
    return data;
  }
}

