angular.module "mindbender.auth", [
    'ngRoute'
]
.directive 'signInOutMenu', ->
    scope: true
    templateUrl: 'app-navbar-signin.html'
    controller: ($scope, $routeParams, $location, Authentication) ->
        $scope.user = Authentication.user


.service "Authentication", ($http, $q) ->
    class Authentication
        constructor: ->
            @user = {
               isSignedIn : false
               name : ''
               photo : ''
            }
            $http.get "/user"
                .success (data) =>
                    if data != ''
                        @user.isSignedIn = true
                        @user.name = data.displayName
                        email = (data.emails && data.emails.length && data.emails[0].value) || null
                        window.UserVoice.push(['identify', {
                            email: email,
                            name: data.displayName,
                            id: email,
                        }]);
                        if data.photos.length == 0
                            @user.thumb = ''
                        else
                            @user.thumb = data.photos[0].value
                    else
                        @user.isSignedIn = false
                .error (err) =>
                    console.error err.message
        init: () =>
    new Authentication()

