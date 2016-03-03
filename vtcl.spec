# vTcl 8.6.x rpm package specification file

%define version	8.6
%define maintr	0
%define patchl	5
%define _prefix	/usr/local

License:	GPLv2+
Summary:	The 'Visual Tcl' (vTcl) GUI builder for TCL/TK
URL:		http://vtcl.sourceforge.net/
Name:		vtcl
Version:	%{version}.%{maintr}
Release:	2
Provides:	vtcl
PreReq:		tcl >= 8.5, tk >= 8.5
Group:		Development
Source:		vtcl-8.6.0.tar.gz
Prefix:		/usr/local
BuildArch:	noarch
BuildRequires:	desktop-file-utils


%description
Visual Tcl (vTcl) is an unparalleled GUI builder for TCL/TK.

%prep
%setup -q

%build
echo "Nothing to build ..."

%install
mkdir -p $RPM_BUILD_ROOT/%{_prefix}
cp -rp $RPM_BUILD_DIR/%{name}-%{version} $RPM_BUILD_ROOT/%{_prefix}

mkdir -p $RPM_BUILD_ROOT/%{_prefix}/share/pixmaps
cp -rp 	$RPM_BUILD_DIR/%{name}-%{version}/images/vTcl-icon.png \
	$RPM_BUILD_ROOT/%{_prefix}/share/pixmaps

desktop-file-install	\
--dir=%{buildroot}%{_datadir}/applications \
	%{_builddir}/%{name}-%{version}/vtcl.desktop
	
mkdir -p $RPM_BUILD_ROOT/%{_prefix}/bin
cd 	$RPM_BUILD_ROOT/%{_prefix}/bin
ln -s ../%{name}-%{version}/%{name} %{name}

#
# Write a fresh vtcl startup wrapper ...
#
rm -f $RPM_BUILD_ROOT/%{_prefix}/%{name}-%{version}/%{name}
echo "#!/bin/sh

#+
# Edit PATH_TO_WISH to fit your requirements
# e.g. if you would like to use ActiveTcl-8.x
# It defaults to your system installation
#-
PATH_TO_WISH=/usr/bin/wish

VTCL_HOME=%{_prefix}/%{name}-%{version}

export PATH_TO_WISH 
export VTCL_HOME
" > $RPM_BUILD_ROOT/%{_prefix}/%{name}-%{version}/%{name}
echo 'exec ${PATH_TO_WISH} ${VTCL_HOME}/vtcl.tcl $*
'>> $RPM_BUILD_ROOT/%{_prefix}/%{name}-%{version}/%{name}

chmod +x $RPM_BUILD_ROOT/%{_prefix}/%{name}-%{version}/%{name}


%clean
echo "Nothing to clean ..."

%files
%defattr(-,root,root)
%{_prefix}/%{name}-%{version}/*
/usr/local/share/applications/vtcl.desktop
/usr/local/share/pixmaps/vTcl-icon.png
/usr/local/bin/%{name}

