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
	late final Translations$admins$en admins = Translations$admins$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$audit$en audit = Translations$audit$en.internal(_root);
	late final Translations$account$en account = Translations$account$en.internal(_root);
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

	/// en: 'Admins'
	String get admins => 'Admins';

	/// en: 'Settings'
	String get settings => 'Settings';

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

	/// en: 'Export CSV'
	String get export => 'Export CSV';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Remove'
	String get remove => 'Remove';
}

// Path: dashboard
class Translations$dashboard$en {
	Translations$dashboard$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overview'
	String get title => 'Overview';

	/// en: 'Platform activity at a glance'
	String get subtitle => 'Platform activity at a glance';

	/// en: 'Total users'
	String get totalUsers => 'Total users';

	/// en: 'New this month'
	String get newThisMonth => 'New this month';

	/// en: 'Open complaints'
	String get openComplaints => 'Open complaints';

	/// en: 'Average rating'
	String get avgRating => 'Average rating';

	/// en: '$n total'
	String totalRatings({required Object n}) => '${n} total';

	/// en: 'Signups (last 6 months)'
	String get signupsOverTime => 'Signups (last 6 months)';

	/// en: 'Rating distribution'
	String get ratingDistribution => 'Rating distribution';

	/// en: 'Not enough data to chart yet'
	String get noChartData => 'Not enough data to chart yet';

	/// en: 'Backend'
	String get backendStatus => 'Backend';

	/// en: 'Healthy'
	String get backendHealthy => 'Healthy';

	/// en: 'Unreachable'
	String get backendDown => 'Unreachable';

	/// en: 'Checking…'
	String get backendChecking => 'Checking…';

	/// en: '${ms} ms'
	String latency({required Object ms}) => '${ms} ms';

	/// en: 'Active users (30 days)'
	String get activeUsers => 'Active users (30 days)';

	/// en: 'Saved words by language'
	String get wordsByLanguage => 'Saved words by language';

	/// en: 'Most-saved words'
	String get topWords => 'Most-saved words';

	/// en: 'Most-reported items'
	String get mostReported => 'Most-reported items';

	/// en: 'Platform analytics'
	String get platformAnalytics => 'Platform analytics';

	/// en: 'Aggregated across all users. Needs collection-group indexes.'
	String get analyticsHint => 'Aggregated across all users. Needs collection-group indexes.';
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

	/// en: 'Decks'
	String get savedDecks => 'Decks';

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

	/// en: 'Make admin'
	String get makeAdmin => 'Make admin';

	/// en: 'Remove admin'
	String get removeAdmin => 'Remove admin';

	/// en: 'Admin'
	String get adminBadge => 'Admin';

	/// en: 'User is now an admin'
	String get madeAdmin => 'User is now an admin';

	/// en: 'Admin access removed'
	String get removedAdmin => 'Admin access removed';

	/// en: 'Saved content'
	String get content => 'Saved content';

	/// en: 'Words'
	String get contentWords => 'Words';

	/// en: 'Sentences'
	String get contentSentences => 'Sentences';

	/// en: 'Videos'
	String get contentVideos => 'Videos';

	/// en: 'Decks'
	String get contentDecks => 'Decks';

	/// en: 'No items'
	String get noContent => 'No items';

	/// en: 'Last 90 days'
	String get activityHeatmap => 'Last 90 days';

	/// en: 'Sort'
	String get sortBy => 'Sort';

	/// en: 'Joined'
	String get sortJoined => 'Joined';

	/// en: 'Streak'
	String get sortStreak => 'Streak';

	/// en: 'Email'
	String get sortEmail => 'Email';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Active'
	String get filterActive => 'Active';

	/// en: 'Disabled'
	String get filterDisabled => 'Disabled';
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

	/// en: 'Time to resolve'
	String get resolutionTime => 'Time to resolve';

	/// en: 'Assigned to'
	String get assignedTo => 'Assigned to';

	/// en: 'Assign to me'
	String get assignToMe => 'Assign to me';

	/// en: 'Unassigned'
	String get unassigned => 'Unassigned';

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

// Path: admins
class Translations$admins$en {
	Translations$admins$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Administrators'
	String get title => 'Administrators';

	/// en: '$n admins'
	String count({required Object n}) => '${n} admins';

	/// en: 'Admin'
	String get columnAdmin => 'Admin';

	/// en: 'Added'
	String get columnAdded => 'Added';

	/// en: 'Add admin'
	String get add => 'Add admin';

	/// en: 'Add an administrator'
	String get addTitle => 'Add an administrator';

	/// en: 'User UID'
	String get uidLabel => 'User UID';

	/// en: 'Firebase Auth UID'
	String get uidHint => 'Firebase Auth UID';

	/// en: 'Email (label)'
	String get emailLabel => 'Email (label)';

	/// en: 'Tip: open a user and use "Make admin" to add them by name.'
	String get addHint => 'Tip: open a user and use "Make admin" to add them by name.';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Remove admin?'
	String get removeTitle => 'Remove admin?';

	/// en: '$email will lose admin access to this dashboard.'
	String removeWarning({required Object email}) => '${email} will lose admin access to this dashboard.';

	/// en: 'Admin added'
	String get added => 'Admin added';

	/// en: 'Admin removed'
	String get removed => 'Admin removed';

	/// en: 'No administrators yet'
	String get noAdmins => 'No administrators yet';

	/// en: 'You'
	String get you => 'You';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Remote config'
	String get remoteConfig => 'Remote config';

	/// en: 'Controls the live mobile app.'
	String get remoteConfigDesc => 'Controls the live mobile app.';

	/// en: 'Announcements'
	String get announcements => 'Announcements';

	/// en: 'Audit log'
	String get auditLog => 'Audit log';

	/// en: 'Maintenance mode'
	String get maintenanceMode => 'Maintenance mode';

	/// en: 'Blocks the mobile app with a maintenance screen.'
	String get maintenanceModeDesc => 'Blocks the mobile app with a maintenance screen.';

	/// en: 'Default daily goal'
	String get dailyGoalDefault => 'Default daily goal';

	/// en: 'Minimum app version'
	String get minAppVersion => 'Minimum app version';

	/// en: 'Settings saved'
	String get saved => 'Settings saved';

	/// en: 'Title'
	String get announcementTitle => 'Title';

	/// en: 'Message'
	String get announcementBody => 'Message';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Post announcement'
	String get post => 'Post announcement';

	/// en: 'Announcement posted'
	String get posted => 'Announcement posted';

	/// en: 'Announcement deleted'
	String get deleted => 'Announcement deleted';

	/// en: 'No announcements'
	String get noAnnouncements => 'No announcements';

	/// en: 'Delete announcement?'
	String get deleteAnnouncement => 'Delete announcement?';
}

// Path: audit
class Translations$audit$en {
	Translations$audit$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Audit log'
	String get title => 'Audit log';

	/// en: 'Admin'
	String get columnAdmin => 'Admin';

	/// en: 'Action'
	String get columnAction => 'Action';

	/// en: 'Target'
	String get columnTarget => 'Target';

	/// en: 'When'
	String get columnDate => 'When';

	/// en: 'No audit entries yet'
	String get noEntries => 'No audit entries yet';

	/// en: 'Disabled user'
	String get action_user_disable => 'Disabled user';

	/// en: 'Enabled user'
	String get action_user_enable => 'Enabled user';

	/// en: 'Deleted user data'
	String get action_user_delete => 'Deleted user data';

	/// en: 'Renamed user'
	String get action_user_rename => 'Renamed user';

	/// en: 'Resolved complaint'
	String get action_complaint_resolve => 'Resolved complaint';

	/// en: 'Dismissed complaint'
	String get action_complaint_dismiss => 'Dismissed complaint';

	/// en: 'Reopened complaint'
	String get action_complaint_reopen => 'Reopened complaint';

	/// en: 'Added admin'
	String get action_admin_add => 'Added admin';

	/// en: 'Removed admin'
	String get action_admin_remove => 'Removed admin';

	/// en: 'Updated config'
	String get action_config_update => 'Updated config';

	/// en: 'Posted announcement'
	String get action_announcement_post => 'Posted announcement';

	/// en: 'Deleted announcement'
	String get action_announcement_delete => 'Deleted announcement';
}

// Path: account
class Translations$account$en {
	Translations$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Preferences'
	String get preferences => 'Preferences';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'User ID'
	String get uid => 'User ID';

	/// en: 'Role'
	String get role => 'Role';

	/// en: 'Administrator'
	String get administrator => 'Administrator';

	/// en: 'Admin since'
	String get memberSince => 'Admin since';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'System'
	String get theme_system => 'System';

	/// en: 'Light'
	String get theme_light => 'Light';

	/// en: 'Dark'
	String get theme_dark => 'Dark';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Sign out'
	String get signOut => 'Sign out';
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
			'nav.admins' => 'Admins',
			'nav.settings' => 'Settings',
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
			'common.export' => 'Export CSV',
			'common.add' => 'Add',
			'common.remove' => 'Remove',
			'dashboard.title' => 'Overview',
			'dashboard.subtitle' => 'Platform activity at a glance',
			'dashboard.totalUsers' => 'Total users',
			'dashboard.newThisMonth' => 'New this month',
			'dashboard.openComplaints' => 'Open complaints',
			'dashboard.avgRating' => 'Average rating',
			'dashboard.totalRatings' => ({required Object n}) => '${n} total',
			'dashboard.signupsOverTime' => 'Signups (last 6 months)',
			'dashboard.ratingDistribution' => 'Rating distribution',
			'dashboard.noChartData' => 'Not enough data to chart yet',
			'dashboard.backendStatus' => 'Backend',
			'dashboard.backendHealthy' => 'Healthy',
			'dashboard.backendDown' => 'Unreachable',
			'dashboard.backendChecking' => 'Checking…',
			'dashboard.latency' => ({required Object ms}) => '${ms} ms',
			'dashboard.activeUsers' => 'Active users (30 days)',
			'dashboard.wordsByLanguage' => 'Saved words by language',
			'dashboard.topWords' => 'Most-saved words',
			'dashboard.mostReported' => 'Most-reported items',
			'dashboard.platformAnalytics' => 'Platform analytics',
			'dashboard.analyticsHint' => 'Aggregated across all users. Needs collection-group indexes.',
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
			'users.savedDecks' => 'Decks',
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
			'users.makeAdmin' => 'Make admin',
			'users.removeAdmin' => 'Remove admin',
			'users.adminBadge' => 'Admin',
			'users.madeAdmin' => 'User is now an admin',
			'users.removedAdmin' => 'Admin access removed',
			'users.content' => 'Saved content',
			'users.contentWords' => 'Words',
			'users.contentSentences' => 'Sentences',
			'users.contentVideos' => 'Videos',
			'users.contentDecks' => 'Decks',
			'users.noContent' => 'No items',
			'users.activityHeatmap' => 'Last 90 days',
			'users.sortBy' => 'Sort',
			'users.sortJoined' => 'Joined',
			'users.sortStreak' => 'Streak',
			'users.sortEmail' => 'Email',
			'users.filterAll' => 'All',
			'users.filterActive' => 'Active',
			'users.filterDisabled' => 'Disabled',
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
			'complaints.resolutionTime' => 'Time to resolve',
			'complaints.assignedTo' => 'Assigned to',
			'complaints.assignToMe' => 'Assign to me',
			'complaints.unassigned' => 'Unassigned',
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
			'admins.title' => 'Administrators',
			'admins.count' => ({required Object n}) => '${n} admins',
			'admins.columnAdmin' => 'Admin',
			'admins.columnAdded' => 'Added',
			'admins.add' => 'Add admin',
			'admins.addTitle' => 'Add an administrator',
			'admins.uidLabel' => 'User UID',
			'admins.uidHint' => 'Firebase Auth UID',
			'admins.emailLabel' => 'Email (label)',
			'admins.addHint' => 'Tip: open a user and use "Make admin" to add them by name.',
			'admins.remove' => 'Remove',
			'admins.removeTitle' => 'Remove admin?',
			'admins.removeWarning' => ({required Object email}) => '${email} will lose admin access to this dashboard.',
			'admins.added' => 'Admin added',
			'admins.removed' => 'Admin removed',
			'admins.noAdmins' => 'No administrators yet',
			'admins.you' => 'You',
			'settings.title' => 'Settings',
			'settings.remoteConfig' => 'Remote config',
			'settings.remoteConfigDesc' => 'Controls the live mobile app.',
			'settings.announcements' => 'Announcements',
			'settings.auditLog' => 'Audit log',
			'settings.maintenanceMode' => 'Maintenance mode',
			'settings.maintenanceModeDesc' => 'Blocks the mobile app with a maintenance screen.',
			'settings.dailyGoalDefault' => 'Default daily goal',
			'settings.minAppVersion' => 'Minimum app version',
			'settings.saved' => 'Settings saved',
			'settings.announcementTitle' => 'Title',
			'settings.announcementBody' => 'Message',
			'settings.active' => 'Active',
			'settings.post' => 'Post announcement',
			'settings.posted' => 'Announcement posted',
			'settings.deleted' => 'Announcement deleted',
			'settings.noAnnouncements' => 'No announcements',
			'settings.deleteAnnouncement' => 'Delete announcement?',
			'audit.title' => 'Audit log',
			'audit.columnAdmin' => 'Admin',
			'audit.columnAction' => 'Action',
			'audit.columnTarget' => 'Target',
			'audit.columnDate' => 'When',
			'audit.noEntries' => 'No audit entries yet',
			'audit.action_user_disable' => 'Disabled user',
			'audit.action_user_enable' => 'Enabled user',
			'audit.action_user_delete' => 'Deleted user data',
			'audit.action_user_rename' => 'Renamed user',
			'audit.action_complaint_resolve' => 'Resolved complaint',
			'audit.action_complaint_dismiss' => 'Dismissed complaint',
			'audit.action_complaint_reopen' => 'Reopened complaint',
			'audit.action_admin_add' => 'Added admin',
			'audit.action_admin_remove' => 'Removed admin',
			'audit.action_config_update' => 'Updated config',
			'audit.action_announcement_post' => 'Posted announcement',
			'audit.action_announcement_delete' => 'Deleted announcement',
			'account.title' => 'Account',
			'account.profile' => 'Profile',
			'account.preferences' => 'Preferences',
			'account.email' => 'Email',
			'account.uid' => 'User ID',
			'account.role' => 'Role',
			'account.administrator' => 'Administrator',
			'account.memberSince' => 'Admin since',
			'account.theme' => 'Theme',
			'account.theme_system' => 'System',
			'account.theme_light' => 'Light',
			'account.theme_dark' => 'Dark',
			'account.language' => 'Language',
			'account.signOut' => 'Sign out',
			_ => null,
		};
	}
}
