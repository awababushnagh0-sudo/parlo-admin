///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$nav$en nav = Translations$nav$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$dashboard$en dashboard = Translations$dashboard$en.internal(_root);
	late final Translations$users$en users = Translations$users$en.internal(_root);
	late final Translations$complaints$en complaints = Translations$complaints$en.internal(_root);
	late final Translations$ratings$en ratings = Translations$ratings$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Parlo Admin'
	String get title => 'Parlo Admin';

	/// en: 'Manage users, complaints and ratings'
	String get tagline => 'Manage users, complaints and ratings';
}

// Path: nav
class Translations$nav$en {
	Translations$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dashboard'
	String get dashboard => 'Dashboard';

	/// en: 'Users'
	String get users => 'Users';

	/// en: 'Complaints'
	String get complaints => 'Complaints';

	/// en: 'Ratings'
	String get ratings => 'Ratings';

	/// en: 'Sign out'
	String get signOut => 'Sign out';

	/// en: 'Toggle theme'
	String get toggleTheme => 'Toggle theme';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Parlo Admin'
	String get title => 'Parlo Admin';

	/// en: 'Sign in with your admin account'
	String get subtitle => 'Sign in with your admin account';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'you@email.com'
	String get hintEmail => 'you@email.com';

	/// en: 'Sign in'
	String get signIn => 'Sign in';

	/// en: 'Signing in…'
	String get signingIn => 'Signing in…';

	/// en: 'Enter your email'
	String get emailRequired => 'Enter your email';

	/// en: 'Enter your password'
	String get passwordRequired => 'Enter your password';

	/// en: 'That email address looks invalid'
	String get invalidEmail => 'That email address looks invalid';

	/// en: 'Incorrect email or password'
	String get wrongCredentials => 'Incorrect email or password';

	/// en: 'This account has been disabled'
	String get userDisabled => 'This account has been disabled';

	/// en: 'Too many attempts. Try again later'
	String get tooManyAttempts => 'Too many attempts. Try again later';

	/// en: 'This account is not an administrator'
	String get notAuthorized => 'This account is not an administrator';

	/// en: 'Something went wrong. Please try again'
	String get somethingWrong => 'Something went wrong. Please try again';

	/// en: 'Signed out'
	String get signedOut => 'Signed out';
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'Nothing here yet'
	String get noData => 'Nothing here yet';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'All'
	String get all => 'All';

	/// en: '—'
	String get none => '—';
}

// Path: dashboard
class Translations$dashboard$en {
	Translations$dashboard$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overview'
	String get title => 'Overview';

	/// en: 'Total users'
	String get totalUsers => 'Total users';

	/// en: 'Active (7 days)'
	String get activeUsers7d => 'Active (7 days)';

	/// en: 'Open complaints'
	String get openComplaints => 'Open complaints';

	/// en: 'Average rating'
	String get avgRating => 'Average rating';

	/// en: 'Total ratings'
	String get totalRatings => 'Total ratings';

	/// en: 'Words saved (platform)'
	String get wordsLearned => 'Words saved (platform)';

	/// en: 'Signups over time'
	String get signupsOverTime => 'Signups over time';

	/// en: 'Streak distribution'
	String get streakDistribution => 'Streak distribution';

	/// en: 'Saved words by language'
	String get wordsByLanguage => 'Saved words by language';

	/// en: 'Not enough data to chart yet'
	String get noChartData => 'Not enough data to chart yet';
}

// Path: users
class Translations$users$en {
	Translations$users$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Users'
	String get title => 'Users';

	/// en: 'Search by email or name'
	String get searchHint => 'Search by email or name';

	/// en: '$n users'
	String count({required Object n}) => '${n} users';

	/// en: 'User'
	String get columnUser => 'User';

	/// en: 'Joined'
	String get columnJoined => 'Joined';

	/// en: 'Words'
	String get columnWords => 'Words';

	/// en: 'Streak'
	String get columnStreak => 'Streak';

	/// en: 'Status'
	String get columnStatus => 'Status';

	/// en: 'Active'
	String get statusActive => 'Active';

	/// en: 'Disabled'
	String get statusDisabled => 'Disabled';

	/// en: 'No users found'
	String get noUsers => 'No users found';

	/// en: 'User detail'
	String get detailTitle => 'User detail';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Activity'
	String get activity => 'Activity';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'User ID'
	String get uid => 'User ID';

	/// en: 'Joined'
	String get joined => 'Joined';

	/// en: 'Last active'
	String get lastActive => 'Last active';

	/// en: 'Saved words'
	String get savedWords => 'Saved words';

	/// en: 'Saved sentences'
	String get savedSentences => 'Saved sentences';

	/// en: 'Saved videos'
	String get savedVideos => 'Saved videos';

	/// en: 'Current streak'
	String get currentStreak => 'Current streak';

	/// en: 'Longest streak'
	String get longestStreak => 'Longest streak';

	/// en: 'Total XP'
	String get totalXp => 'Total XP';

	/// en: 'Edit profile'
	String get edit => 'Edit profile';

	/// en: 'Edit profile'
	String get editTitle => 'Edit profile';

	/// en: 'Disable user'
	String get disableUser => 'Disable user';

	/// en: 'Enable user'
	String get enableUser => 'Enable user';

	/// en: 'Delete user data'
	String get deleteUser => 'Delete user data';

	/// en: 'This account is disabled — the user cannot use the app.'
	String get disabledBanner => 'This account is disabled — the user cannot use the app.';

	/// en: 'Delete user data?'
	String get deleteTitle => 'Delete user data?';

	/// en: 'This permanently deletes $email's profile, saved words, sentences, videos, decks and stats from Firestore. The login account itself is not removed (that needs the Admin SDK). This cannot be undone.'
	String deleteWarning({required Object email}) => 'This permanently deletes ${email}\'s profile, saved words, sentences, videos, decks and stats from Firestore. The login account itself is not removed (that needs the Admin SDK). This cannot be undone.';

	/// en: 'Profile updated'
	String get userUpdated => 'Profile updated';

	/// en: 'User disabled'
	String get userDisabled => 'User disabled';

	/// en: 'User enabled'
	String get userEnabled => 'User enabled';

	/// en: 'User data deleted'
	String get userDeleted => 'User data deleted';
}

// Path: complaints
class Translations$complaints$en {
	Translations$complaints$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Complaints'
	String get title => 'Complaints';

	/// en: 'Status'
	String get filterStatus => 'Status';

	/// en: '$n complaints'
	String count({required Object n}) => '${n} complaints';

	/// en: 'User'
	String get columnUser => 'User';

	/// en: 'Category'
	String get columnCategory => 'Category';

	/// en: 'Message'
	String get columnMessage => 'Message';

	/// en: 'Status'
	String get columnStatus => 'Status';

	/// en: 'Date'
	String get columnDate => 'Date';

	/// en: 'No complaints'
	String get noComplaints => 'No complaints';

	/// en: 'Complaint'
	String get detailTitle => 'Complaint';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Reported item'
	String get target => 'Reported item';

	/// en: 'Message'
	String get message => 'Message';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Admin note'
	String get adminNote => 'Admin note';

	/// en: 'Add an internal note (optional)'
	String get adminNoteHint => 'Add an internal note (optional)';

	/// en: 'Mark resolved'
	String get markResolved => 'Mark resolved';

	/// en: 'Dismiss'
	String get markDismissed => 'Dismiss';

	/// en: 'Reopen'
	String get reopen => 'Reopen';

	/// en: 'Complaint updated'
	String get statusUpdated => 'Complaint updated';

	/// en: 'Open'
	String get status_open => 'Open';

	/// en: 'Resolved'
	String get status_resolved => 'Resolved';

	/// en: 'Dismissed'
	String get status_dismissed => 'Dismissed';

	/// en: 'Bug'
	String get category_bug => 'Bug';

	/// en: 'Wrong translation'
	String get category_wrong_translation => 'Wrong translation';

	/// en: 'Offensive content'
	String get category_offensive => 'Offensive content';

	/// en: 'Other'
	String get category_other => 'Other';

	/// en: 'The app'
	String get target_app => 'The app';

	/// en: 'Word'
	String get target_word => 'Word';

	/// en: 'Sentence'
	String get target_sentence => 'Sentence';

	/// en: 'Video'
	String get target_video => 'Video';
}

// Path: ratings
class Translations$ratings$en {
	Translations$ratings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ratings'
	String get title => 'Ratings';

	/// en: 'Average rating'
	String get average => 'Average rating';

	/// en: '$n ratings'
	String count({required Object n}) => '${n} ratings';

	/// en: 'based on $n ratings'
	String basedOn({required Object n}) => 'based on ${n} ratings';

	/// en: 'Star distribution'
	String get distribution => 'Star distribution';

	/// en: 'User'
	String get columnUser => 'User';

	/// en: 'Type'
	String get columnType => 'Type';

	/// en: 'Stars'
	String get columnStars => 'Stars';

	/// en: 'Comment'
	String get columnComment => 'Comment';

	/// en: 'Date'
	String get columnDate => 'Date';

	/// en: 'No ratings yet'
	String get noRatings => 'No ratings yet';

	/// en: 'App'
	String get type_app => 'App';

	/// en: 'Word'
	String get type_word => 'Word';

	/// en: 'Sentence'
	String get type_sentence => 'Sentence';

	/// en: 'Video'
	String get type_video => 'Video';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Parlo Admin',
			'app.tagline' => 'Manage users, complaints and ratings',
			'nav.dashboard' => 'Dashboard',
			'nav.users' => 'Users',
			'nav.complaints' => 'Complaints',
			'nav.ratings' => 'Ratings',
			'nav.signOut' => 'Sign out',
			'nav.toggleTheme' => 'Toggle theme',
			'auth.title' => 'Parlo Admin',
			'auth.subtitle' => 'Sign in with your admin account',
			'auth.email' => 'Email',
			'auth.password' => 'Password',
			'auth.hintEmail' => 'you@email.com',
			'auth.signIn' => 'Sign in',
			'auth.signingIn' => 'Signing in…',
			'auth.emailRequired' => 'Enter your email',
			'auth.passwordRequired' => 'Enter your password',
			'auth.invalidEmail' => 'That email address looks invalid',
			'auth.wrongCredentials' => 'Incorrect email or password',
			'auth.userDisabled' => 'This account has been disabled',
			'auth.tooManyAttempts' => 'Too many attempts. Try again later',
			'auth.notAuthorized' => 'This account is not an administrator',
			'auth.somethingWrong' => 'Something went wrong. Please try again',
			'auth.signedOut' => 'Signed out',
			'common.search' => 'Search',
			'common.retry' => 'Retry',
			'common.cancel' => 'Cancel',
			'common.save' => 'Save',
			'common.delete' => 'Delete',
			'common.close' => 'Close',
			'common.confirm' => 'Confirm',
			'common.loading' => 'Loading…',
			'common.noData' => 'Nothing here yet',
			'common.refresh' => 'Refresh',
			'common.all' => 'All',
			'common.none' => '—',
			'dashboard.title' => 'Overview',
			'dashboard.totalUsers' => 'Total users',
			'dashboard.activeUsers7d' => 'Active (7 days)',
			'dashboard.openComplaints' => 'Open complaints',
			'dashboard.avgRating' => 'Average rating',
			'dashboard.totalRatings' => 'Total ratings',
			'dashboard.wordsLearned' => 'Words saved (platform)',
			'dashboard.signupsOverTime' => 'Signups over time',
			'dashboard.streakDistribution' => 'Streak distribution',
			'dashboard.wordsByLanguage' => 'Saved words by language',
			'dashboard.noChartData' => 'Not enough data to chart yet',
			'users.title' => 'Users',
			'users.searchHint' => 'Search by email or name',
			'users.count' => ({required Object n}) => '${n} users',
			'users.columnUser' => 'User',
			'users.columnJoined' => 'Joined',
			'users.columnWords' => 'Words',
			'users.columnStreak' => 'Streak',
			'users.columnStatus' => 'Status',
			'users.statusActive' => 'Active',
			'users.statusDisabled' => 'Disabled',
			'users.noUsers' => 'No users found',
			'users.detailTitle' => 'User detail',
			'users.profile' => 'Profile',
			'users.activity' => 'Activity',
			'users.name' => 'Name',
			'users.uid' => 'User ID',
			'users.joined' => 'Joined',
			'users.lastActive' => 'Last active',
			'users.savedWords' => 'Saved words',
			'users.savedSentences' => 'Saved sentences',
			'users.savedVideos' => 'Saved videos',
			'users.currentStreak' => 'Current streak',
			'users.longestStreak' => 'Longest streak',
			'users.totalXp' => 'Total XP',
			'users.edit' => 'Edit profile',
			'users.editTitle' => 'Edit profile',
			'users.disableUser' => 'Disable user',
			'users.enableUser' => 'Enable user',
			'users.deleteUser' => 'Delete user data',
			'users.disabledBanner' => 'This account is disabled — the user cannot use the app.',
			'users.deleteTitle' => 'Delete user data?',
			'users.deleteWarning' => ({required Object email}) => 'This permanently deletes ${email}\'s profile, saved words, sentences, videos, decks and stats from Firestore. The login account itself is not removed (that needs the Admin SDK). This cannot be undone.',
			'users.userUpdated' => 'Profile updated',
			'users.userDisabled' => 'User disabled',
			'users.userEnabled' => 'User enabled',
			'users.userDeleted' => 'User data deleted',
			'complaints.title' => 'Complaints',
			'complaints.filterStatus' => 'Status',
			'complaints.count' => ({required Object n}) => '${n} complaints',
			'complaints.columnUser' => 'User',
			'complaints.columnCategory' => 'Category',
			'complaints.columnMessage' => 'Message',
			'complaints.columnStatus' => 'Status',
			'complaints.columnDate' => 'Date',
			'complaints.noComplaints' => 'No complaints',
			'complaints.detailTitle' => 'Complaint',
			'complaints.category' => 'Category',
			'complaints.target' => 'Reported item',
			'complaints.message' => 'Message',
			'complaints.status' => 'Status',
			'complaints.adminNote' => 'Admin note',
			'complaints.adminNoteHint' => 'Add an internal note (optional)',
			'complaints.markResolved' => 'Mark resolved',
			'complaints.markDismissed' => 'Dismiss',
			'complaints.reopen' => 'Reopen',
			'complaints.statusUpdated' => 'Complaint updated',
			'complaints.status_open' => 'Open',
			'complaints.status_resolved' => 'Resolved',
			'complaints.status_dismissed' => 'Dismissed',
			'complaints.category_bug' => 'Bug',
			'complaints.category_wrong_translation' => 'Wrong translation',
			'complaints.category_offensive' => 'Offensive content',
			'complaints.category_other' => 'Other',
			'complaints.target_app' => 'The app',
			'complaints.target_word' => 'Word',
			'complaints.target_sentence' => 'Sentence',
			'complaints.target_video' => 'Video',
			'ratings.title' => 'Ratings',
			'ratings.average' => 'Average rating',
			'ratings.count' => ({required Object n}) => '${n} ratings',
			'ratings.basedOn' => ({required Object n}) => 'based on ${n} ratings',
			'ratings.distribution' => 'Star distribution',
			'ratings.columnUser' => 'User',
			'ratings.columnType' => 'Type',
			'ratings.columnStars' => 'Stars',
			'ratings.columnComment' => 'Comment',
			'ratings.columnDate' => 'Date',
			'ratings.noRatings' => 'No ratings yet',
			'ratings.type_app' => 'App',
			'ratings.type_word' => 'Word',
			'ratings.type_sentence' => 'Sentence',
			'ratings.type_video' => 'Video',
			_ => null,
		};
	}
}
