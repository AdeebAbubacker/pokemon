class Result {
	String? name;
	String? url;

	Result({this.name, this.url});

	factory Result.fromJson(Map<String, dynamic> json) => Result(
				name: json['name'] as String?,
				url: json['url'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'name': name,
				'url': url,
			};
}
